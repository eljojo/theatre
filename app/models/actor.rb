class Actor < ApplicationRecord
  has_many :messages
  belongs_to :parent, class_name: 'Actor', required: false

  validates_presence_of :kind

  serialize :state
end
