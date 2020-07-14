class MessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Calculator.process(id)
  end
end
