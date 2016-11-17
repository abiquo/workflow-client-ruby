class ProcessTasksJob < ApplicationJob
    queue_as :pending_tasks

    def perform(tasks)
        log = Rails.logger

        task_details = AbiquoAPIHelpers.retrieve_tasks_details(tasks)

        # Only process if task is configured to be processed
        type = task_details[:task_type]
        unless APP_CONFIG['approval_task_types'].include? type
            log.info "Task with type #{type} is not configured to be processed. Accepting."
            AcceptTaskJob.perform_later(tasks)
            return
        end

        # Perform default if user role is approval role
        if task_details[:user_role] == APP_CONFIG['approval_role']
            log.info "Requester #{task_details[:username]} has approval role #{APP_CONFIG['approval_role']}"
            log.info "Performing default #{APP_CONFIG['default_role_action']}."
            case APP_CONFIG['default_role_action']
            when 'ACCEPT'
                AcceptTaskJob.perform_later(tasks, false)
            when 'CANCEL'
                CancelTaskJob.perform_later(tasks, false)
            end
            return
        end

        # Retrieve email notification list
        log.info "Retrieving approval emails..."
        abq = AbiquoAPI.new($abiquo_config)
        ent_lnk = AbiquoAPI::Link.new href: 'admin/enterprises',
                                      type: 'application/vnd.abiquo.enterprises+json',
                                      client: abq
        abq_enterprise = ent_lnk.get.select {|e| e.name == task_details[:enterprise] }.first
        approval_users = abq_enterprise.link(:users).get.select {|u| u.link(:role).title == APP_CONFIG['approval_role'] }
        approval_emails = approval_users.map {|u| u.email }

        log.debug "Task details are #{task_details.inspect}"
        log.debug "Approval emails are #{approval_emails.inspect}"

        # Handle empty notification address
        if approval_emails.count == 0
            log.info "No approval emails found, taking default action #{APP_CONFIG['default_action']}"
            case APP_CONFIG['default_action']
            when 'ACCEPT'
                AcceptTaskJob.perform_later(tasks, false)
            when 'CANCEL'
                CancelTaskJob.perform_later(tasks, false)
            end
        else
            # Queue the Mailer
            TasksMailer.send_approval_email(task_details, approval_emails).deliver_later
        end
    end

    private

    def perform_default(action, tasks)
        case action
        when 'ACCEPT'
            AcceptTaskJob.perform_later(tasks, false)
        when 'CANCEL'
            CancelTaskJob.perform_later(tasks)
        end
    end
end
