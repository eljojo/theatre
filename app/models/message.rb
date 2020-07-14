class Message < ApplicationRecord
  belongs_to :actor

  scope :sorted, -> { order('id asc') }

  scope :to_process, -> { sorted.where(processed: false) }

  serialize :params
end
