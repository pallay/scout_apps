class UserReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time]   = Time.zone.now
    data[:total_users]  = User.count(:conditions => ignore_users)
    data[:active_users] = User.find(:all, :conditions => ['user_logs.created_at > ?', Time.now - 1.week], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:user_churn]   = User.find(:all, :conditions => ['user_logs.created_at < ?', Time.now - 3.months], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Users",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
