class MessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(id)
    actor_with_lock(id) do |actor, helper|
      if (message = actor.inbox.first)
        helper.call(message)
      else
        helper.logger.info("no message found")
      end
    end
  end

  private

  def actor_with_lock(id)
    Actor.transaction do
      actor = Actor.lock.find(id)
      helper_instance = actor.helper_instance
      yield(actor, helper_instance)
      @outbox = helper_instance.outbox
    end
    @outbox.each(&:queue_job!)
  end
end
