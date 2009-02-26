class Virality < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:invitations_(total)] = Invitation.count(:conditions => ignore_users)
    data[:invitations_(av_per_user)] = sprintf("%.1f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:conditions => ignore_users, :group => :user_id).size)
    data[:invitations_(redeemed)] = Invitation.count(:condition => ignore_users + 'and used is true')

    data[:referrals_seen_(total)] = UserLog.find_log_by('stories', 'show').count
    data[:referrals_seen_(non_users)] = UserLog.find_log_by('stories', 'show').without_user.count 

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output kpi virality",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
