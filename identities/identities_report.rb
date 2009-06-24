class IdentitiesReport < Scout::Plugin

  def run
    # ENV['RAILS_ENV'] = 'production' 
    ENV['RAILS_ENV'] = option('environment')
    # require "/opt/ensembli.com/current/config/environment"
    require "#{option('path_to_app')}/config/environment"

    # ignore_users = "id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    ignore_users = "id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:twitter_identities_total] = TwitterIdentity.count(:conditions => ignore_users)
    # data[:facebook_identities_total] = FacebookIdentity.count(:conditions => ignore_users)
    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Identities",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
