class StoryReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:stories_presented_(av_num_per_user)] = sprintf("%02d", Story.viewed.count.to_f/User.ignore_users.count)
    data[:stories_pages_presented_(av_num_per_user)] = sprintf("%02d",  UserLog.find_log_by('stories','index').find(:all, :conditions => ignore_users).size.to_f/UserLog.find_log_by('stories','index').find(:all, :conditions => ignore_users, :group => :user_id).size)
    data[:stories_read_(av_num_per_user)] = sprintf("%02d", Story.read.count.to_f/User.ignore_users.count)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Stories",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end
end
