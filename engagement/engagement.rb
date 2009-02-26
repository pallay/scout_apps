class Engagement < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:stories_read_(av_num_per_user)] = sprintf("%02d", Story.count(:conditions => ignore_users + 'and stories.personal_attention > 1').to_f/User.count(:conditions => ignore_users))
    data[:referrals_total] = Referral.count(:conditions => ignore_users)
    data[:referrals_unique] = Referral.count(:conditions => ignore_users, :distinct => true, :select => :story_id)
    data[:referrals_sent_(av_num_per_user)] = sprintf("%.1f", Referral.count(:conditions => ignore_users).to_f/Referral.count(:conditions => ignore_users, :group => :user_id).size)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output kpi engagement",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
