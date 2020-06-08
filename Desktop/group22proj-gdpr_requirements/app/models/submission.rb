class Submission < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
  has_one :feedback
  belongs_to :contest
  belongs_to :user
  has_many :likes
  validates :contest_id, :user, :attachment, presence: true
#rwar
end
