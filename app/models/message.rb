class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Actor', required: false
  belongs_to :receiver, class_name: 'Actor'

  scope :sorted, -> { order('id asc') }

  scope :to_process, -> { sorted.where(processed: false) }

  serialize :params

  def queue_job!
    puts("enqueueing message_id=#{id} receiver_id=#{receiver_id} action=#{action.inspect} params=#{params.inspect}")
    MessageProcessorJob.perform_later(receiver_id)
  end
end
