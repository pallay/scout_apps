class UsersReports < Scout::Plugin
  
  def build_report
    ENV['RAILS_ENV'] = option('environment')
    begin
      require "#{@options[:path_to_app]}/config/environment"
      report(:total_users => User.count
      )
    rescue
      error(:subject => "Unable to monitor Users",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
