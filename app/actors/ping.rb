class Ping < GenServer
  def self.start
    super(0) # set initial state
  end

  def handle_call(message)
    if message.created_at < 1.minute.ago
      puts "stopping stale ping due to #{message.inspect} being too old"
      return
    end

    case message.action
    when 'ping' then pong!(message.sender_id)
    else raise("I don't know how to #{message.action}")
    end
  end

  def pong!(actor_id)
    @state += 1
    puts "pong! number #{@state}"

    time = rand(1..5)
    puts "sleeping #{time} seconds"
    sleep(time)

    queue_message(actor_id, 'pong')
  end
end
