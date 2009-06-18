class SolrLatency < Scout::Plugin

  def run
    ENV['RAILS_ENV'] = option(:environment)
    require "/Users/pallay/Development/ensembli/rails/config/environment"
    # require "#{option(:path_to_app)}/config/environment"

    data = Hash.new

    {:report => data}
  rescue
    {:error => {:subject => "Unable to monitor Solr Latency",
                :body    => "The following exception was raised: #{$!.message} \n #{$!.backtrace}" }
    }
  end

end
