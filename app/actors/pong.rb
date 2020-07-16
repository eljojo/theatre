class Pong < GenServer
  def self.start
    super(0) # set initial state
  end

  def handle_call(message)
    if message.created_at < 1.minute.ago
      logger.info "stopping stale pong due to #{message.inspect} being too old"
      return
    end

    case message.action
    when 'pong' then ping!(message.sender_id)
    else raise("I don't know how to #{message.action}")
    end
  end

  def ping!(actor_id)
    @state += 1
    logger.info "ping! number #{@state}"

    time = rand(1..5)
    logger.info "sleeping #{time} seconds"
    sleep(time)

    queue_message(actor_id, 'ping')
  end
end
