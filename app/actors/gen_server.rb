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
      record = Actor.find(id)
      server = new(id, record.state)
      logger.debug("[#{name}][id=#{id}] action=#{action.inspect} params=#{params.inspect}")
      server.handle_call(action, params)
      new_state = server.state
      record.update!(state: new_state)
      logger.debug("[#{name}][id=#{id}] new_state = #{new_state.inspect}")
      puts("")
      nil
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
