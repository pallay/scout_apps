class UsersReports < Scout::Plugin

  require 'rubygems'
  gem 'activesupport', '=2.1.0'
  require 'activesupport'
  
  def build_report
    ENV['RAILS_ENV'] = option('environment')
    ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    begin
      require "#{@options[:path_to_app]}/config/environment"
      report(:total_users => User.count(:conditions => ignore_users))
    rescue
      error(:subject => "Unable to monitor Users",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
