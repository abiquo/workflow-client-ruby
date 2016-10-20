class TasksMailer < ApplicationMailer
    default from: APP_CONFIG['mail_from']
    
    def send_approval_email(task_details, emails)
        to_line = emails.join(',')
        @tasks = task_details
        @render_links = APP_CONFIG['email_render_links']
        mail(to: to_line, subject: APP_CONFIG['approval_subject'])
    end

    def send_requester_email(task_details, email)
        @tasks = task_details
        mail(to: email, subject: APP_CONFIG['requester_subject'])
    end
end
