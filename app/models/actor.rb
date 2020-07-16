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
    kind.constantize.new(self)
  end

  def create_message!(from: nil, to: nil, action:, params: nil)
    sender = from || id
    receiver = to || id
    raise("invalid sender and receiver") if sender == receiver
    Message.create!(sender_id: sender, receiver_id: receiver, action: action, params: params)
  end

  def send_message!(from: nil, to: nil, action:, params: nil)
    create_message!(from: from, to: to, action: action, params: params).queue_job!
  end

  def log_prefix
    @log_prefix ||= "[#{kind}##{id}]".freeze
  end
end
