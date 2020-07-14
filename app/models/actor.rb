class Actor < ApplicationRecord
  has_many :messages
  belongs_to :parent, class_name: 'Actor'

  validates_presence_of :kind
end
