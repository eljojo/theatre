class Actor < ApplicationRecord
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  belongs_to :parent, class_name: 'Actor', required: false

  validates_presence_of :kind

  serialize :state

  def inbox
    received_messages.to_process
  end

  def helper_instance
    kind.constantize.new(id, state)
  end

  def create_message!(from: nil, action:, params: nil)
    Message.create!(sender_id: from, receiver_id: id, action: action, params: params)
  end

  def send_message!(from: nil, action:, params: nil)
    message = create_message!(from: from, action: action, params: params)
    message.queue_job!
  end
end
