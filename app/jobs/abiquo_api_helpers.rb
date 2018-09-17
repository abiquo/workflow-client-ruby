class AbiquoAPIHelpers
    def self.retrieve_tasks_details(tasks)
        log = Rails.logger

        log.info "Connecting to Abiquo API..."
        abq = AbiquoAPI.new(ABQ_CONFIG)

        task_details = {}

        first_task = tasks.first
        # Retrieve the user
        log.info "Retrieving user..."
        user_lnk = AbiquoAPI::Link.new(JSON.parse(first_task.user_url).merge(client: abq))
        abq_user = user_lnk.get

        # Retrieve the enterprise
        log.info "Retrieving user's enterprise..."
        abq_enterprise = abq_user.link(:enterprise).get

        # Retrieve the VM
        log.info "Retrieving VM for the first task..."
        vm_lnk = AbiquoAPI::Link.new(JSON.parse(first_task.target_url).merge(client: abq))
        vm = vm_lnk.get

        # Get the username that created the task
        log.info "Retrieving VM details..."
        task_details[:username] = abq_user.name
        task_details[:user_role] = abq_user.link(:role).title

        # Task type
        task_details[:task_type] = first_task.task_type
        # VDC name
        task_details[:vdc_name] = vm.link(:virtualdatacenter).get.name
        # DC name
        task_details[:dc_name] = vm.link(:virtualdatacenter).get.link(:location).title
        # vApp name
        task_details[:vapp_name] = vm.link(:virtualappliance).get.name
        # Enterprise name
        task_details[:enterprise] = abq_enterprise.name

        # Retrieve VM detauls
        log.info "Retrieving all VM's details..."
        all_tasks_vms = tasks.map do |t|
            vm_lnk = AbiquoAPI::Link.new(JSON.parse(t.target_url).merge(client: abq, accept: 'application/vnd.abiquo.virtualmachine+json'))
            { abq_vm: vm_lnk.get, task: t }
        end

        task_details[:vm_details] = self.build_virtualmachines_details(all_tasks_vms)
        task_details
    end

    private

    def self.build_virtualmachines_details(vms)
        vm_hashes = []
        vms.each do |vmh|
            # retrieve the disks
            vm = vmh[:abq_vm]
            task = vmh[:task]
            vm_disks = vm.link(:harddisks).get
            vm_volumes = vm.link(:volumes).get
            disks = []
            vm_disks.each do |disk|
                disks << {
                    type: 'HARDDISK',
                    sequence: disk.sequence,
                    size: disk.sizeInMb,
                    name: disk.name
                }
            end
            vm_volumes.each do |vol|
                disks << {
                    type: 'VOLUME',
                    sequence: vol.sequence,
                    size: vol.sizeInMB,
                    name: vol.name
                }
            end

            vm_hashes << {
                task: task.uuid,
                name: vm.name,
                cpu: vm.cpu,
                ram: vm.ram,
                disks: disks,
                persistent: vm.respond_to?(:persistent)
            }
        end
        vm_hashes
    end
end