class AdvertisingValue < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:interests_total] = Interest.count(:conditions => ignore_users)
    data[:interests_unique] = Interest.count(:conditions => ignore_users, :distinct => true, :select => :description)
    data[:interests_(av_num_per_user)] = sprintf("%.1f", Interest.count(:conditions => ignore_users).to_f/Interest.count(:conditions => ignore_users, :group => :user_id).size)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output kpi advertising value",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
