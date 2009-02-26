class EnsembliLinkReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:ensembli_link_total_(seen_by_all)] = UserLog.count(:conditions => ["controller = 'stories' and action = 'show' and #{ignore_users}"])
    data[:ensembli_link_total_(seen_by_non_user)] = UserLog.count(:conditions => ["controller = 'stories' and action = 'show' and user_id is null"])
    data[:ensembli_link_(av_num_per_user)] = sprintf("%.2f", UserLog.count(:conditions => ["controller = 'stories' and action = 'show' and user_id is not null and #{ignore_users}"]).to_f/UserLog.count(:conditions => ["controller = 'stories' and action = 'show' and user_id is not null and #{ignore_users}"], :group => :user_id).size)

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Ensembli Link",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end
end
