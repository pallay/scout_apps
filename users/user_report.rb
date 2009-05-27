class UserReport < Scout::Plugin

  def run
    # ENV['RAILS_ENV'] = 'production' 
    ENV['RAILS_ENV'] = option('environment')
    # require "/opt/ensembli.com/current/config/environment"
    require "#{option('path_to_app')}/config/environment"

    # ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    ignore_users = "id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:users_total] = User.count(:conditions => ignore_users)
    data[:twitter_identities_total] = TwitterIdentity.count(:conditions => ignore_users)
    # data[:facebook_identities_total] = FacebookIdentity.count(:conditions => ignore_users)
    data[:users_new_registrations] = User.count(:conditions => ignore_users + "and created_at > '#{1.week.ago}'")
    data[:users_on_now] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 10.minutes], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:users_with_activity_last_week] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 1.week], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:users_with_activity_last_month] = User.count(:conditions => ['user_logs.created_at > ?', Time.now - 1.month], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
    data[:existing_users_with_activity_last_month] = User.activity_within(1.month).all.size - User.count(:conditions => ['created_at > ?', 1.month.ago])
    data[:users_with_no_activity_three_month] = User.count(:conditions => ['user_logs.created_at < ?', Time.now - 3.month], :select => 'users.id', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Users",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
