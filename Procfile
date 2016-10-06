web:                bundle exec rails s
mailer_worker:      bundle exec env QUEUE='mailers' rake resque:work
approval_worker:    bundle exec env QUEUE='pending_tasks' rake resque:work
requester_worker:   bundle exec env QUEUE='accept,cancel' rake resque:work
