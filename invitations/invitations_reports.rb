class InvitationReports < Scout::Plugin
  
  def build_report
    users_to_ignore = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    ENV['RAILS_ENV'] = option('environment')
    begin
      require @options[:path_to_app] + "/config/environment"
      report(:total_invitations => Invitation.count,
             :average_invitation_per_user => sprintf("%.1f",Invitation.count(:conditions => users_to_ignore).to_f/Invitation.count(:group => :user_id, :conditions => users_to_ignore).size)
      )  
    rescue
      error(:subject => "Unable to monitor Invitations",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
