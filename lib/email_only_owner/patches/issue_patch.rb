module EmailOnlyOwner
  module Patches
    module IssuePatch

      def self.included(base)
        base.class_eval do
          include InstanceMethods
          
          # Only include the owner/author
          #
          # TODO: won't load in the module so it has to be amc'd
          def recipients_with_email_only_owner
            if project.module_enabled?(:email_only_owner)
              if author && author.active?
                [author.mail]
              else
                []
              end
            else
              recipients_without_email_only_owner
            end
          end

          alias_method_chain :recipients, :email_only_owner

        end
      end

      module InstanceMethods
        # Block all watchers from notifications
        def watcher_recipients
          if project.module_enabled?(:email_only_owner)
            []
          else
            super
          end
        end
      end
    end
  end
end
