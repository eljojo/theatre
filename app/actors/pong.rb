class Pong < GenServer
  def self.start
    super(0) # set initial state
  end

  def handle_call(message)
    case message.action
    when 'pong' then ping!(message.params.fetch(:id))
    else raise("I don't know how to #{message.action}")
    end
  end

  def ping!(actor_id)
    @state += 1
    puts "ping! number #{@state}"

    time = rand(1..5)
    puts "sleeping #{time} seconds"
    sleep(time)

    queue_message(actor_id, 'ping', { id: id })
  end
end
