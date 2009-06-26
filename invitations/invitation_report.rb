class InvitationReport < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option('environment')
    require "#{option('path_to_app')}/config/environment"

    ignore_users = "user_id not in(1,2,3,21,24,29)"

    data = Hash.new
    data[:invitations_total] = Invitation.count
    data[:invitations_sent_av_num_per_user] = sprintf("%.2f", Invitation.count(:conditions => ignore_users).to_f/Invitation.count(:group => :user_id, :conditions => ignore_users).size).to_f

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Invitations",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
