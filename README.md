# Workflow client for Abiquo

This repo contains a workflow client implemented in Ruby (Rails) for the Abiquo CMP.

This basic client will stop operations and send a notification email to a predefined role. That email contains action buttons to approve or reject the tasks.

## Requirements

- Ruby 2.3.1
- Redis
- Abiquo CMP *must* reach this app to post the workflow data
- The application needs to be able to reach the Abiquo API

## Installation

Clone this repository and ```cd``` into it. Run:

```
bundle install
```

## Configuration

The configuration is done in the following files under the ```config``` folder

### abiquo.yml

Contains the necessary data to connecto to the Abiquo API.

```
production:
    abiquo_api_url: https://wf.bcn.abiquo.com/api
    abiquo_username: admin
    abiquo_password: xabiquo
    connection_options:
        ssl:
            verify: false
```

This application uses the [abiquo-api](https://rubygems.org/gems/abiquo-api) gem. The options provided are those supported by such gem when creating a new connection.

### config.yml

Contains parameters to control the behaviour of the client. Here's the reference of supported options:

Key               | Description                                                      | Type   | Default
------------------|------------------------------------------------------------------|--------|-------------
`template_path`   | The path under `app/views` to look for the email templates       | String | default
`logo_file`      | A logo file to be added as an attachement to the email. The file must exist under `app/assets/images` | String | ""
`default_action` | The action to take by default when no approver's email can be found | String | CANCEL
`default_role_action` | The action to take by default when the requestuer role is the same as one configured in `approval_role` | String | ACCEPT
`approval_role` | The role responsible for approving requests. Users in the enterprise with this role will be notified for approval | String | ENTERPRISE_ADMIN
`mail_from` | `From` line in the emails sent by the application  | String | some_address@test.com
`approval_subject` | The subject in the emails sent asking for approval | String | You have a pending task pending for approval
`requester_subject` | The subject in the emails sent to notify approval result | String | A pending task has been updated
`approval_task_types` | Comma sepparated list of task types to process. | String | DEPLOY,UNDEPLOY,RECONFIGURE
`email_render_links` | Whether or not to include links in the email to accept or reject tasks | String | true
`smtp_settings` | The [SMTP settings](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration) for the Rails application | Hash | 

In addition to the Rails ActionMailer config, the `smtp_settings` include some additional properties:

Key                   | Description                                                          | Type   | Default
----------------------|----------------------------------------------------------------------|--------|-------------
`email_link_host`     | The host used to build the links in the action buttons in emails     | String | localhost
`email_link_port`     | The port used to build the links in the action buttons in emails     | FixNum | 3000
`email_link_protocol` | The protocol used to build the links in the action buttons in emails | String | http
`email_link_path`     | The path used to build the links in the action buttons in emails, if you are running this behind a proxy. | String | ""

### database.yml

Configure the database settings just like any other Rails app. For further reference, check [Rails configuration reference](http://edgeguides.rubyonrails.org/configuring.html).

### resque.yml

This app uses [resque](https://github.com/resque/resque) for delayed job execution. Resque uses Redis backend, so you will need to set config parameters in this file.

## Running the app

`cwd` into the app directory and run:

```
bundle exec rake db:migrate
foreman start
```

Or for the production mode:

```
export RAILS_ENV=production
bundle exec rake db:migrate
foreman start
```

## Docker

Everything tastes better with Docker!

There's a `Dockerfile` provided allow to build a docker image:

```
docker build -t=wf-client .
docker run -d -e RAILS_ENV=production wf-client bundle exec rake db:migrate
docker run -d -e RAILS_ENV=production wf-client bundle exec foreman start
```

# License and Authors

* Author:: Marc Cirauqui (marc.cirauqui@abiquo.com)

Copyright:: 2016, Abiquo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
