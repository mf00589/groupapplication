class Feedback < ApplicationRecord

  belongs_to :submission

  validates :rating, presence: true
  validates :description, presence: true

end
