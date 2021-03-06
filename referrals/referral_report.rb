class ReferralReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:referrals_total] = Referral.count(:conditions => ignore_users)
    data[:referrals_twitter] = TwitterReferral.count(:conditions => ignore_users)
    data[:referrals_twitter] = EmailReferral.count(:conditions => ignore_users)
    data[:referrals_unique] = Referral.count(:conditions => ignore_users, :distinct => true, :select => :story_id)
    data[:referrals_sent_av_num_per_user] = sprintf("%.2f", Referral.count(:conditions => ignore_users).to_f/Referral.count(:group => :user_id, :conditions => ignore_users).size)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Referrals",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
