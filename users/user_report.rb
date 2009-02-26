class UserReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time]   = Time.zone.now
    data[:users_(total)] = User.count(:conditions => ignore_users)
    data[:users_(new_registrations)] = User.count(:conditions => ignore_users + "and created_at > '#{1.week.ago}'")

    data[:users_with_activity_(last_week)] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 1.week], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:users_with_activity_(last_month)] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 1.month], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:users_with_no_activity_(three_month)] = User.count(:conditions => ['user_logs.created_at < ?', Time.now - 3.month], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Users",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
