class TasksMailer < ApplicationMailer
    default from: APP_CONFIG['mail_from']
    layout false
        
    def send_approval_email(task_details, emails)
        if APP_CONFIG['logo_file']
            attachments.inline[APP_CONFIG['logo_file']] = File.read(Rails.root.join('app', 'assets', 'images', APP_CONFIG['logo_file']))
        end

        to_line = emails.join(',')
        @tasks = task_details
        @render_links = APP_CONFIG['email_render_links']
        mail(to: to_line, subject: APP_CONFIG['approval_subject'], template_path: APP_CONFIG['template_path'])
    end

    def send_requester_email(task_details, email)
            binding.pry
        if APP_CONFIG['logo_file']
            attachments.inline[APP_CONFIG['logo_file']] = File.read(Rails.root.join('app', 'assets', 'images', APP_CONFIG['logo_file']))
        end
        
        @tasks = task_details
        mail(to: email, subject: APP_CONFIG['requester_subject'], template_path: APP_CONFIG['template_path'])
    end
end
