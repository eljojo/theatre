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
      record
    end
  end

  attr_reader :id, :state, :outbox

  def initialize(id, state)
    @id = id
    @state = state
    @outbox = []
  end

  def handle_call(message)
  end

  private

  def queue_message(receiver_id, action, params = nil)
    @outbox << create_message!(receiver_id, action, params)
  end

  def create_message!(to, action, params = nil)
    Message.create!(sender_id: id, receiver_id: to, action: action, params: params)
  end
end
