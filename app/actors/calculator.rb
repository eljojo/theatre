class Calculator < GenServer
  def self.start(value = 0)
    super(value)
  end

  def handle_call(action, params)
    case action
    when '+' then @state += params
    when '-' then @state -= params
    when 'print' then puts("the value is #{@state}")
    else raise("I don't know how to #{action}")
    end
  end
end
