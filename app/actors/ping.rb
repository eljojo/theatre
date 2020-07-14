class Ping < GenServer
  def handle_call(action, params)
    case action
    when 'ping' then pong!(params.fetch(:id))
    else raise("I don't know how to #{action}")
    end
  end

  def pong!(actor_id)
    time = rand(1..5)
    puts "pong! sleeping #{time} seconds"
    sleep(time)
    enqueue_message(Message.create!(actor_id: actor_id, action: 'pong', params: { id: id }))
  end
end
