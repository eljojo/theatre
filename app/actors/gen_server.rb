class GenServer
  class << self
    def logger
      return @logger if @logger
      @logger = Logger.new(Logger::DEBUG)
      @logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
      @logger
    end

    def start(state)
      record = Actor.create!(kind: name, state: state)
      logger.debug("[#{name}][id=#{record.id}] new server! state = #{state.inspect}")
      puts("")
      record.id
    end

    def call(id, action, params = {})
      Message.create!(actor_id: id, action: action, params: params)
      MessageProcessorJob.perform_later(id)
      nil
    end

    def process(id)
      Actor.transaction do
        actor = Actor.lock.find(id)
        message = actor.messages.to_process.first
        process_message!(actor, message) if message
      end
    end

    def process_message!(actor, message)
      action, params = message.action, message.params
      logger.debug("[#{name}][id=#{actor.id}] action=#{action.inspect} params=#{params.inspect}")

      server = new(actor.id, actor.state)
      server.handle_call(action, params)
      new_state = server.state

      actor.update!(state: new_state)
      message.update!(processed: true, new_state: new_state)
      logger.debug("[#{name}][id=#{actor.id}] new_state = #{new_state.inspect}")
    end
  end

  attr_reader :state

  def initialize(id, state)
    @id = id
    @state = state
  end

  def handle_call(action, params)
  end
end