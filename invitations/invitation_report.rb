class InvitationReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = 'production' 
    #ENV['RAILS_ENV'] = option('environment')
    require "/opt/ensembli.com/current/config/environment"
    #require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"

    data = Hash.new
    data[:invitations_total] = Invitation.count
    data[:invitations_redeemed] = Invitation.used.count
    data[:invitations_not_sent] = Invitation.waiting.count
    data[:invitations_sent_and_unused] = Invitation.count(:conditions => 'sent_at is not null and used is false')
    data[:invitations_sent_unused_and_old] = Invitation.count(:conditions => 'sent_at is not null and used is false')
    data[:invitations_sent_av_num_per_user] = sprintf("%.2f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:group => :user_id, :conditions => ignore_users).size).to_f

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Invitations",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
