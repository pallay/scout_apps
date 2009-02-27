class Virality < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = 'production' 
    #ENV['RAILS_ENV'] = option('environment')
    require "/opt/ensembli.com/current/config/environment"
    #require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"

    data = Hash.new

    data[:invitations_total] = Invitation.count
    data[:invitations_av_per_user] = sprintf("%.1f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:conditions => ignore_users, :group => :user_id).size)
    data[:invitations_redeemed] = Invitation.used.count

    data[:referrals_seen_total] = UserLog.find_log_by('stories', 'show').count(:conditions => ignore_users)
    data[:referrals_seen_non_users] = UserLog.find_log_by('stories', 'show').without_user.count 

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output KPI Virality",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
