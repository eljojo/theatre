class MessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Calculator.process(id)
    sleep(rand(3))
  end
end
