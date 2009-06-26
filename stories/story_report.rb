class StoryReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:stories_presented_av_num_per_user] = sprintf("%02d", Story.viewed.count.to_f/User.count)
    data[:stories_pages_presented_av_num_per_user] = sprintf("%02d",  UserLog.count(:conditions => ignore_users + "and controller='stories' and action='index'").to_f/UserLog.count(:conditions => ignore_users + "and controller='stories' and action='index'", :group => :user_id).size)
    data[:stories_read_av_num_per_user] = sprintf("%02d", Story.read.count.to_f/User.count)
    data[:stories_click_through_av_num_per_user] = sprintf("%02d", Story.count(:conditions => 'stories.personal_attention > 2').to_f/User.count)
    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Stories",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end
end
