class Virality < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,21,24,29)"

    data = Hash.new

    data[:invitations_total] = Invitation.count
    data[:invitations_av_per_user] = sprintf("%.1f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:conditions => ignore_users, :group => :user_id).size)

    data[:referrals_seen_total] = UserLog.count(:conditions => ignore_users + {"and controller='stories' and action='show'"})
    data[:referrals_seen_non_users] = UserLog.count(:conditions => ignore_users + {"and controller='stories' and action='show' and user_id is null"})

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output KPI Virality",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
