# Preview all emails at http://localhost:3000/rails/mailers/tasks_mailer
class TasksMailerPreview < ActionMailer::Preview

    @@tasks = {
            username: "Marc",
            task_type: "DEPLOY",
            vdc_name: "chirauki_vdc",
            vapp_name: "vapp_chirauki_vdc",
            dc_name: "Abiquo-DC",
            enterprise: "chirauki_wf",
            vm_details: [
                {
                    task_action: 'CANCELLED',
                    name: "ABQ_142897c0-5c7b-4589-8dc6-c5a391a6d24d",
                    cpu: 1,
                    ram: 128,
                    persistent: true,
                    task: 8,
                    disks: [
                        {
                            type: "VOLUME",
                            sequence: 1,
                            size: 1024,
                            name: nil
                        },
                        {
                            type: "HARDDISK",
                            sequence: 1,
                            size: 1024,
                            name: 'data disk'
                        }
                    ]
                }
            ]
        }

    def send_approval_email
        to_line = ["marc.cirauqui@abiquo.com"]
        TasksMailer.send_approval_email(@@tasks, to_line)
    end

    def send_requester_email
        TasksMailer.send_requester_email(@@tasks, 'test@test.com')
    end
end
