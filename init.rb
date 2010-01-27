require 'redmine'

Redmine::Plugin.register :redmine_email_only_owner do
  name 'Redmine Email Only Owner plugin'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-misc'
  author_url 'http://www.littlestreamsoftware.com'
  description 'This plugin adds a Project module that will make issue events only send emails to the issue owner.'
  version '0.1.0'

  project_module :email_only_owner do
    # TODO: Redmine requires a permission to define a module
    permission :email_only_owner, {}, :public => true
  end
end
