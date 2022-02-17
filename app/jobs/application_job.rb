class ApplicationJob
  include Sidekiq::Worker

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") } # Use c.exists? on Redis >= 4.2.0
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

  # TODO: something like this seems reasonable.. except need to figure how to catch them
  # it likely means something is wrong in SF
  # sidekiq_retry_in do |count, exception|
  #   case exception
  #     when OpenStax::Salesforce::Remote::Errors
  #       count * 0 # no reties needed on SF errors
  #   end
  # end

end
