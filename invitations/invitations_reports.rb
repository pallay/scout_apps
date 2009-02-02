class InvitationReports < Scout::Plugin

  require 'rubygems'
  gem 'activesupport', '=2.1.0'
  require 'activesupport'
  
  def build_report
    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    ENV['RAILS_ENV'] = option('environment')
    begin
      require @options[:path_to_app] + "/config/environment"
      report(:total_invitations => Invitation.count,
             :average_invitation_per_user => sprintf("%.1f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:group => :user_id, :conditions => ignore_users).size)
      )  
    rescue
      error(:subject => "Unable to monitor Invitations",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
