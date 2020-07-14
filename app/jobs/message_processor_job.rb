class MessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(id)
    actor_class = Actor.find(id).kind.constantize
    actor_class.process(id)
  end
end
