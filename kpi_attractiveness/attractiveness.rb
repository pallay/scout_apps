class Attractiveness < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = 'production' 
    #ENV['RAILS_ENV'] = option('environment')
    require "/opt/ensembli.com/current/config/environment"
    #require "#{option('path_to_app')}/config/environment"

    # ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    ignore_users = "id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:users_new_registrations] = User.count(:conditions => ignore_users + "and created_at > '#{1.week.ago}'")
    data[:users_with_activity_last_week] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 1.week], :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:users_with_no_activity_three_month] = User.count(:conditions => ['user_logs.created_at < ?', Time.now - 3.month], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size

    {:report => data}
  rescue
    {:error => {:subject => "Unable to output KPI Attractiveness",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
