class MessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(id)
    actor_with_lock(id) do |actor, helper|
      if (message = actor.inbox.first)
        process_message!(actor, message, helper)
      else
        logger.info("no message found")
      end
    end
  end

  private

  def actor_with_lock(id)
    Actor.transaction do
      actor = Actor.lock.find(id)
      @helper_instance = actor.helper_instance
      yield(actor, @helper_instance)
    end
    @helper_instance.outbox.each(&:queue_job!)
  end

  def process_message!(actor, message, helper)
    log_prefix = "[#{helper.class.name}##{message.receiver_id}]"

    action, params = message.action, message.params
    logger.debug("#{log_prefix} action=#{action.inspect} params=#{params.inspect}")

    helper.handle_call(message)
    new_state = helper.state
    message.update!(processed: true, new_state: new_state)

    actor.update!(state: new_state)
    logger.debug("#{log_prefix} new_state=#{new_state.inspect}")
  end
end
