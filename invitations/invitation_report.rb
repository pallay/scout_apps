class InvitationReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,11,12,13,14,15,17,21,24,29)"
    Time.zone = 'London'

    data = Hash.new
    data[:scout_time] = Time.zone.now
    data[:invitations_total] = Invitation.count(:conditions => ignore_users)
    data[:invitations_redeemed] = Invitation.count(:conditions => ignore_users + 'and used is true')
    data[:invitations_not_sent] = Invitation.count(:conditions => ignore_users + 'and sent_at is null')
    data[:invitations_sent_and_unused] = Invitation.count(:conditions => ignore_users + 'and sent_at is not null and used is false')
    data[:invitations_sent_unused_and_old] = Invitation.count(:conditions => ignore_users + 'and sent_at is not null and used is false')
    data[:invitations_sent_(av_num_per_user)] = sprintf("%.2f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:group => :user_id, :conditions => ignore_users).size)
           
    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Invitations",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
