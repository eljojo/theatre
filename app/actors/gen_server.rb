class GenServer
  class << self
    def start(state)
      record = Actor.create!(kind: name, state: state)
      Rails.logger.info("#{record.log_prefix} new server! state = #{state.inspect}")
      record
    end
  end

  attr_reader :outbox, :state
  delegate :id, :parent_id, :parent, to: :@actor

  def initialize(actor)
    @actor = actor
    @state = actor.state
    @outbox = []
    logger.debug("loaded with state=#{state.inspect}")
  end

  def call(message)
    raise "message #{message.inspect} already processed!" if message.processed?

    action, params = message.action, message.params
    logger.debug("action=#{action.inspect} params=#{params.inspect}")

    handle_call(message)
    logger.debug("new_state=#{state.inspect}")

    message.update!(processed: true, new_state: state)
    @actor.update!(state: state)
  end

  def logger
    return @logger if @logger
    @logger = Logger.new(Logger::DEBUG)
    @logger.formatter = proc { |severity, datetime, progname, msg| "#{@actor.log_prefix} #{msg}\n" }
    @logger
  end

  private

  def queue_message(receiver_id, action, params = nil)
    @outbox << @actor.create_message!(to: receiver_id, action: action, params: params)
  end
end
