require File.dirname(__FILE__) + '/../../../../test_helper'

class EmailOnlyOwner::Patches::IssuePatchTest < ActiveSupport::TestCase
  context "Issue#recipients" do
    setup do
      @project = Project.generate!
      @author = User.generate_with_protected!
      @assignee = User.generate_with_protected!
      @project_member = User.generate_with_protected!
      @role = Role.generate!
      Member.generate!(:roles => [@role], :user_id => @project_member.id, :project => @project, :mail_notification => true)

      @issue = Issue.generate!(:author => @author, :assigned_to => @assignee, :project => @project, :tracker => @project.trackers.first)
    end

    context "with the module disabled" do
      setup do
        @project.enabled_modules.select {|em| em.name == 'email_only_owner'}.each {|em| em.destroy}
      end
      
      should "include the author's mail" do
        assert @issue.recipients.include?(@author.mail)
      end
      
      should "include the assigned to user's mail" do
        assert @issue.recipients.include?(@assignee.mail)
      end
      
      should "include the project recipients mail" do
        assert @issue.recipients.include?(@project_member.mail)
      end
    end

    context "with the module enabled" do
      should "only include the author's mail" do
        assert_equal [@author.mail], @issue.recipients
      end
    end
  end
  
  context "Issue#watcher_recipients" do
    setup do
      @project = Project.generate!
      @author = User.generate_with_protected!
      @watcher1 = User.generate_with_protected!
      @watcher2 = User.generate_with_protected!

      @issue = Issue.generate!(:author => @author, :assigned_to => @assignee, :project => @project, :tracker => @project.trackers.first)
      @issue.add_watcher(@watcher1)
      @issue.add_watcher(@watcher2)
    end

    context "with the module disabled" do
      setup do
        @project.enabled_modules.select {|em| em.name == 'email_only_owner'}.each {|em| em.destroy}
      end
      
      should "include the watchers' mail" do
        assert_equal [@watcher1.mail, @watcher2.mail], @issue.watcher_recipients
      end
    end

    context "with the module enabled" do
      should "return nothing" do
        assert_equal [], @issue.watcher_recipients
      end
    end

  end
end
