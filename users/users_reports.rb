require 'rubygems'
gem 'activesupport', '=2.1.0'
require 'activesupport'

class UsersReports < Scout::Plugin
  
  def build_report
    ENV['RAILS_ENV'] = option('environment')
    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    begin
      require "#{option('path_to_app')}/config/environment.rb"
      report(:total_users  => User.count(:conditions => ignore_users),
             :active_users => User.find(:all, :conditions => ['user_logs.created_at > ?', Time.now - 1.week], :select => 'users.id, users.login', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
             :user_churn  => User.find(:all, :conditions => ['user_logs.created_at < ?', Time.now - 6.months], :select => 'users.id, users.login', :joins => 'LEFT JOIN user_logs ON user_logs.user_id = users.id', :group => 'users.id').size
      )
    rescue
      error(:subject => "Unable to monitor Users",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
