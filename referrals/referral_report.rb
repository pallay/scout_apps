class ReferralReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time]      = Time.zone.now
    data[:total_referrals] = Referral.count(:conditions => ignore_users)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Referrals",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
