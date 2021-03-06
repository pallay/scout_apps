class UserReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:users_total] = User.count(:conditions => ignore_users)
    data[:users_new_registrations] = User.count(:conditions => ignore_users + "and created_at > '#{1.week.ago}'")
    data[:users_on_now] = UserLog.count(:distinct => true, :select => :user_id, :conditions => ['created_at > ?', Time.now - 10.minutes])
    data[:users_with_activity_last_week] =  UserLog.count(:distinct => true, :select => :user_id, :conditions => ['created_at > ?', Time.now - 1.week])
    data[:users_with_activity_last_month] = UserLog.count(:distinct => true, :select => :user_id, :conditions => ['created_at > ?', Time.now - 1.month])
    data[:existing_users_with_activity_last_month] = UserLog.count(:distinct => true, :select => :user_id, :conditions => ['created_at > ?', Time.now - 1.month]) - User.count(:conditions => ['created_at > ?', 1.month.ago])
    data[:users_with_no_activity_three_month] = UserLog.count(:having => ['max(created_at) < ?', Time.now - 3.month], :select => :user_id, :distinct => true)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Users",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
