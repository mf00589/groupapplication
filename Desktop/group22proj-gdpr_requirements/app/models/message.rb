class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :body, presence: true, length: {minimum: 1, maximum: 500}

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
