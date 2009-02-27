class StoryReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = 'production'
    #ENV['RAILS_ENV'] = option('environment')
    require "/opt/ensembli.com/current/config/environment"
    #require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"

    data = Hash.new
    data[:stories_presented_av_num_per_user] = sprintf("%02d", Story.count(:conditions => 'viewed_at is not null').to_f/User.count)
    data[:stories_pages_presented_av_num_per_user] = sprintf("%02d",  UserLog.find_log_by('stories','index').count(:conditions => ignore_users).to_f/UserLog.find_log_by('stories','index').count(:conditions => ignore_users, :group => :user_id).size)
    data[:stories_read_av_num_per_user] = sprintf("%02d", Story.count(:conditions => 'stories.personal_attention > 1').to_f/User.count)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Stories",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end
end
