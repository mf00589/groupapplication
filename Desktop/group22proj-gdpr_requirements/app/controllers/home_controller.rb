class HomeController < ApplicationController
  # before_action :set_submission, only: [:leaderboard, :live_chat, :home]
  # before_action :set_contest, only: [:leaderboard, :live_chat, :home]
  before_action :authenticate_user!, :except => [:home, :leaderboard]

  def home
    @ongoing_contests = Contest.where(paid_for: true, evaluated: false).where("ending_date > '#{Time.now.utc.iso8601}'")
    @contests_evaluated = Contest.where(paid_for: true, evaluated: true).where("ending_date <= '#{Time.now.utc.iso8601}'")
    @total_payout = 0
    payout_total = 0
    @contests_evaluated.each do |contest|
      if contest.payout_amount != 0
        payout_total += contest.payout_amount
      end
    end
    @total_payout = payout_total / 100
  end

  def live_chat
    session[:conversations] ||= []

    @users = User.all.where.not(id: current_user)

    @conversations = Conversation.includes(:recipient, :messages)
                         .find(session[:conversations])
  end

  def leaderboard
    @ranking = User.all.order('contests_won DESC').limit(10)
  end

  def my_submissions
    user = current_user
    total_earnings = 0
    @currently_entered_in = []
    @waiting_for_vendor = []
    @contests_won = []

    # contests the user has entered in
    submissions = Submission.where(user_id: user.id)
    if !submissions.empty?
      @currently_entered_in = submissions.map(&:contest).select { |c| !c.evaluated && c.ending_date > Time.now.utc.iso8601 }

      @waiting_for_vendor = submissions.map(&:contest).select { |c| !c.evaluated && c.paid_for && c.ending_date <= Time.now.utc.iso8601 }

      contest_ended = Contest.where(paid_for: true, evaluated: true).where("ending_date <= '#{Time.now.utc.iso8601}'").order('updated_at DESC')

      @contests_won = contest_ended.where(first_place: user.id)
                          .or(contest_ended.where(second_place: user.id))
                          .or(contest_ended.where(third_place: user.id))

      @contests_won.each do |contest|
        if contest.first_place.to_i == user.id
          total_earnings += contest.first_prize
        elsif !contest.second_place.nil?
          if contest.second_place.to_i == user.id
            total_earnings += contest.second_prize
          elsif !contest.third_place.nil? && contest.third_place.to_i == user.id
            total_earnings += contest.third_prize
          end
        end
      end
    end
    @total_earnings = total_earnings.to_f / 100.0
  end

  def my_contests
    user = current_user
    contests = Contest.all.where(user_id: user.id)
    total_paid_out = 0
    @ongoing_contests = []
    @unpaid_contests = []
    @unranked_contests = []
    @evaluated_contests = []

    if !contests.empty?
      @ongoing_contests = Contest.where(user_id: user.id, paid_for: true, evaluated: false).where("ending_date > '#{Time.now.utc.iso8601}'").order('updated_at DESC')
      @unpaid_contests = Contest.where(user_id: user.id, paid_for: false).order('updated_at DESC')
      @unranked_contests = Contest.where(user_id: user.id, paid_for: true, evaluated: false).where("ending_date <= '#{Time.now.utc.iso8601}'").order('updated_at DESC')
      @evaluated_contests = Contest.where(user_id: user.id, evaluated: true).order('updated_at DESC')

      @evaluated_contests.each do |contest|
        total_paid_out += contest.payout_amount
      end
    end
    @total_paid_out = total_paid_out / 100
    if params.has_key?(:state)
      state = params[:state]
      unless state_matches?(state)
        status 403
        redirect_to contests_path
      end

      # Send the authorization code to Stripe's API.
      code = params[:code]
      begin
        response = Stripe::OAuth.token({
                                           grant_type: 'authorization_code',
                                           code: code,
                                       })
      rescue Stripe::OAuth::InvalidGrantError
        status 400
        redirect_to contests_path
      rescue Stripe::StripeError
        status 500
        redirect_to contests_path
      else
        connected_account_id = response.stripe_user_id
        save_account_id(connected_account_id)
      end
    end
  end

  def state_matches?(state_parameter)
    # Load the same state value that you randomly generated for your OAuth link.
    saved_state = current_user.authenticatable_salt
    saved_state == state_parameter
  end

  def save_account_id(id)
    # Save the connected account ID from the response to your database.
    current_user.stripe_id = id
    user = current_user
    user.stripe_id = id
    user.save
    flash[:notice] = 'Your Stripe Account has been linked!'
  end
  #
  # def set_submission
  #   @submission = Submission.find_by(id: params[:id])
  # end
  #
  # def set_contest
  #   @contest = Contest.find_by(id: params[:contest_id]) || Contest.find(submission_params[:contest_id])
  # end


end
