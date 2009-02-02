class ReferralsReports < Scout::Plugin
  
  def build_report
    ENV['RAILS_ENV'] = option('environment')
    begin
      require "#{@options[:path_to_app]}/config/environment"
      report(:total_referrals => Referral.count
      )
    rescue
      error(:subject => "Unable to monitor Referrals",
            :body    => "The following exception was raised:
                          \n\n#{$!.message}\n\n#{$!.backtrace}")
    end
  end

end
