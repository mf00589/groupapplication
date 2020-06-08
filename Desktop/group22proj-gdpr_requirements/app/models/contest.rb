class Contest < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :payout_amount, presence: true, numericality: {greater_than_or_equal_to: 100, less_than_or_equal_to: 299999700,
                                                           message: "must be least £4.00 and should not exceed £2,999,997.00"}
  validates :first_prize, presence: true, numericality: {greater_than_or_equal_to: 100, less_than_or_equal_to: 99999900,
                                                         message: "must be least £2.00 and should not exceed £999,999.00"}
  validates :second_prize, presence: true, numericality: {greater_than_or_equal_to: 100, less_than_or_equal_to: 99999900,
                                                          message: "must be least £1.00 and should not exceed £999,999.00"}
  validates :third_prize, presence: true, numericality: {greater_than_or_equal_to: 100, less_than_or_equal_to: 99999900,
                                                         message: "must be least £1.00 and should not exceed £999,999.00"}
  # should not in the future
  validates :start_date, presence: true

  # should not be in the past
  validates :ending_date, presence: true

  validate :payouts_add_up
  validate :payouts_hierarchy
  validate :selected_winners
  # validate :min_duration
  # validate :deny_payout_changes

  has_many :submissions, dependent: :destroy
  has_many :videos, dependent: :destroy
  belongs_to :user


  def ending_on
    ending_date.in_time_zone(Time.zone).strftime("%d/%m/%Y %H:%M")
  end

  def has_ended
    Time.current > ending_date
  end

  def show_payout
    amount = (self.payout_amount).to_f
    '%.2f' % (amount / 100.0)
  end

  def show_first_prize
    amount = self.first_prize.to_f
    '%.2f' % (amount / 100.0)
  end

  def show_second_prize
    amount = self.second_prize.to_f
    '%.2f' % (amount / 100.0)
  end

  def show_third_prize
    amount = self.third_prize.to_f
    '%.2f' % (amount / 100.0)
  end

  private

  def payouts_add_up
    if first_prize + second_prize + third_prize != payout_amount
      errors.add(:payout_amount, 'error: Prizes should add up to the total Payout amount!')
    end
  end

  def payouts_hierarchy
    if second_prize >= first_prize
      errors.add(:second_prize, 'error: 2nd Place Prize should not exceed 1st Place Prize!')
    elsif third_prize > second_prize
      errors.add(:third_prize, 'error: 3rd Place Prize must be less than or equal to 2nd Place Prize!')
    elsif third_prize > first_prize
      errors.add(:third_prize, 'error: 3rd Place Prize should not exceed 1st Place Prize!')
    end
  end

  def selected_winners
    if !first_place.nil? || !second_place.nil? || !third_place.nil?
      if first_place == second_place || first_place == third_place
        errors.add(:first_place, 'error: a user cannot be selected for more than 1 place')
      elsif second_place == third_place
        errors.add(:second_place, 'error: a user cannot be selected for more than 1 place')
      end
    end
  end

  # def min_duration
  #   # date_start = Date.parse(ending_date)
  #   # date_now = Date.today
  #   # days_passed = (Date.today - date_sent).to_i
  #   if ending_date < (DateTime.now + 7.days)
  #     errors.add(:ending_date, 'error: must be at least 7 days from today.')
  #   end
  # end
  #
  # def deny_payout_changes
  #   if payout_amount_changed? && self.persisted?
  #     errors.add(:payout_amount, 'cannot be changed after creating a contest.')
  #   end
  # end

end

