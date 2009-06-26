class Engagement < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,21,24,29)"
    ignore_user_ids = "id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:stories_read_av_num_per_user] = sprintf("%02d", Story.read.count(:conditions => ignore_users).to_f/User.count(:conditions => ignore_users))
    data[:referrals_total] = Referral.count(:conditions => ignore_users)
    data[:referrals_unique] = Referral.count(:conditions => ignore_users, :distinct => true, :select => :story_id)
    data[:referrals_sent_av_num_per_user] = sprintf("%.1f", Referral.count(:conditions => ignore_users).to_f/Referral.count(:conditions => ignore_users, :group => :user_id).size)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output KPI Engagement",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
