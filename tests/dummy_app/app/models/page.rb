class Page < ApplicationRecord
  belongs_to :account

  validates :account, presence: true
  validates :title,   presence: true, uniqueness: true
  validates :content, presence: true

  scope :with_state, ->(states) { where state: Array.wrap(states) }
end
