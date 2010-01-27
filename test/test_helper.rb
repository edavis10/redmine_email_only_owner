# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

# Helpers
class ActiveSupport::TestCase
  def setup
    User.anonymous
    begin
      Role.non_member
    rescue
      non_member = Role.generate!
      non_member.builtin = Role::BUILTIN_NON_MEMBER
      non_member.save!
    end
  end
end
