class Ping < GenServer
  def self.start
    super(0) # set initial state
  end

  def self.demo
    ping = self.start
    pong = Pong.start
    pong.send_message!(to: ping, action: 'ping')
  end

  def handle_call(message)
    if message.created_at < 1.minute.ago
      logger.info "stopping stale ping due to #{message.inspect} being too old"
      return
    end

    case message.action
    when 'ping' then pong!(message.sender_id)
    else raise("I don't know how to #{message.action}")
    end
  end

  def pong!(actor_id)
    @state += 1
    logger.info "pong! number #{@state}"

    time = rand(1..5)
    logger.info "sleeping #{time} seconds"
    sleep(time)

    queue_message(actor_id, 'pong')
  end
end
