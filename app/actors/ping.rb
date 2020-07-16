class Ping < GenServer
  def self.start
    super(0) # set initial state
  end

  def handle_call(message)
    case message.action
    when 'ping' then pong!(message.params.fetch(:id))
    else raise("I don't know how to #{message.action}")
    end
  end

  def pong!(actor_id)
    @state += 1
    puts "pong! number #{@state}"

    time = rand(1..5)
    puts "sleeping #{time} seconds"
    sleep(time)

    queue_message(actor_id, 'pong', { id: id })
  end
end
