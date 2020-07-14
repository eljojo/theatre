class Pong < GenServer
  def handle_call(action, params)
    case action
    when 'pong' then ping!(params.fetch(:id))
    else raise("I don't know how to #{action}")
    end
  end

  def ping!(actor_id)
    time = rand(1..5)
    puts "ping! sleeping #{time} seconds"
    sleep(time)
    enqueue_message(Message.create!(actor_id: actor_id, action: 'ping', params: { id: id }))
  end
end
