class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit, :update, :destroy, :evaluate, :submit_ranking]
  before_action :require_same_user, only: [:edit, :update, :destroy, :evaluate, :submit_ranking]
  before_action :authenticate_user!, :except => [:show, :index]

  # GET /contests
  # GET /contests.json
  def index
    # find and retrieve only the contests that have been paid & has not ended
    # @contests2 = Contest.where(paid_for: true).order('updated_at DESC').select {|c| c.has_ended }
    contest_category = params[:category]
    if !contest_category.nil?
      @contests = Contest.where(paid_for: true, category: contest_category).where("ending_date > '#{Time.now.utc.iso8601}'").order('updated_at DESC')
      @past_contests = Contest.all.where(paid_for: true, evaluated: true, category: contest_category).where("ending_date <= '#{Time.now.utc.iso8601}'").order('updated_at DESC')
    else
      @contests = Contest.where(paid_for: true).where("ending_date > '#{Time.now.utc.iso8601}'").order('updated_at DESC')
      @past_contests = Contest.all.where(paid_for: true, evaluated: true).where("ending_date <= '#{Time.now.utc.iso8601}'").order('updated_at DESC')
    end

  end

  def evaluate
    @contest = Contest.find(params[:id])
    @submissions = Submission.all.where(contest_id: @contest.id)
  end

  def submit_ranking
    # add check number of submissions before processing transfer
    @contest = Contest.find(params[:id])
    @submissions = Submission.all.where(contest_id: @contest.id)
    if !@submissions.empty?
      if @contest.has_ended && !@contest.evaluated && @contest.paid_for
        respond_to do |format|
          if @contest.update(ranking_params)
            @first_place_user = User.find_by_id(@contest.first_place.to_i)
            @first_place_user.contests_won += 1
            @first_place_user.save
            transfer = Stripe::Transfer.create({
                                                   amount: (@contest.first_prize.to_i),
                                                   currency: 'GBP',
                                                   destination: @first_place_user.stripe_id,
                                                   transfer_group: '{ORDER10}',
                                               })

            if !@contest.second_place.nil?
              @second_place_user = User.find_by_id(@contest.second_place.to_i)

              @second_place_user.contests_won += 1
              @second_place_user.save
              transfer2 = Stripe::Transfer.create({
                                                      amount: (@contest.second_prize.to_i),
                                                      currency: 'GBP',
                                                      destination: @second_place_user.stripe_id,
                                                      transfer_group: '{ORDER10}',
                                                  })
              if !@contest.third_place.nil?
                @third_place_user = User.find_by_id(@contest.third_place.to_i)
                @third_place_user.contests_won += 1
                @third_place_user.save
                transfer3 = Stripe::Transfer.create({
                                                        amount: (@contest.third_prize.to_i),
                                                        currency: 'GBP',
                                                        destination: @third_place_user.stripe_id,
                                                        transfer_group: '{ORDER10}',
                                                    })
              end
            end
            @contest.evaluated = true
            @contest.save
            format.html { redirect_to @contest, notice: 'Ranking saved. Contest prize money have paid out to the selected users!' }
          else
            format.html { render :evaluate }
          end
        end
      elsif !@contest.paid_for
        redirect_to contests_path, alert: 'You have not deposited funds to pay out the successful participant(s) for this contest.'
      elsif @contest.evaluated
        redirect_to contests_path, alert: 'You have already paid out prize money to the successful participant(s).'
      else
        redirect_to contest_path, alert: 'You can only payout the prize money once this contest has ended.'
      end
    else
      redirect_to contests_path, alert: 'You cannot rank a contest with no submissions.'
    end
  end


  # GET /contests/1
  # GET /contests/1.json
  def show
    if current_user
      state = current_user.authenticatable_salt
      @stripe_btn_url = "https://connect.stripe.com/express/oauth/authorize?client_id=ca_H77EPzbfQs9D9Ickbf94U4uMt9feQCKY&state=#{state}&stripe_user[email]=#{current_user.email}"
      if params.has_key?(:success)
        if params[:success] == 'true'
          verify_payment
        else
          flash[:alert] = 'Deposit for Contest Payout was cancelled.'
        end
      end


      unless @contest.paid_for
        @session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            line_items: [{
                             name: @contest.name,
                             description: 'Contest Payout Deposit',
                             amount: @contest.payout_amount,
                             currency: 'gbp',
                             quantity: 1,
                         }],
            success_url: contest_url(id: @contest.id, success: true),
            cancel_url: contest_url(id: @contest.id, success: false),
            client_reference_id: @contest.id
        )
      end
    end

    if @contest.evaluated
      @winner_1st = User.find_by(id: @contest.first_place)
      @winner_2nd = User.find_by(id: @contest.second_place)
      @winner_3rd = User.find_by(id: @contest.third_place)
    end
    @contest = Contest.find(params[:id])
    @videos = Video.all.where(contest_id: @contest.id)
  end

  # GET /contests/new
  def new
    @contest = current_user.contests.build
    @contest.user = current_user
  end

  # GET /contests/1/edit
  def edit
  end

  # POST /contests
  # POST /contests.json
  def create

    @contest = current_user.contests.new(contest_params)

    respond_to do |format|
      if @contest.save
        format.html { redirect_to my_contests_path, notice: 'Your Contest has been created! Deposit funds to start your contest.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /contests/1
  # PATCH/PUT /contests/1.json
  def update
    @contest = Contest.find(params[:id])
    respond_to do |format|
      if @contest.update(contest_params)
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
      end
    else
      format.html { render :edit }
    end
  end


  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest.destroy
    respond_to do |format|
      format.html { redirect_to contests_url, notice: 'Contest was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contest
    @contest = Contest.find(params[:id])
  end

  def params_decimal_to_int(params_in, keys)
    keys.each do |key|
      params_in[key] = BigDecimal(params_in[key]) * 100
    end
    params_in
  end

  # Only allow a list of trusted parameters through.
  def contest_params
    if defined? @contest
      params_decimal_to_int(
          params.require(:contest).permit(:name, :description, :category, :first_prize, :second_prize,
                                          :third_prize, :start_date, :ending_date, :is_student_only),
          [:first_prize, :second_prize, :third_prize]
      )

    else
      params_decimal_to_int(
          params.require(:contest).permit(:name, :description, :category, :payout_amount, :first_prize, :second_prize,
                                          :third_prize, :start_date, :ending_date, :is_student_only),
          [:payout_amount, :first_prize, :second_prize, :third_prize]
      )
    end

  end

  def ranking_params
    params.require(:contest).permit(:first_place, :second_place, :third_place)
  end

  def require_same_user
    if current_user != @contest.user
      flash[:alert] = 'You do not have permissions to perform this action.'
      redirect_to contests_path
    end
  end

  def verify_payment
    events = Stripe::Event.list({
                                    type: 'checkout.session.completed',
                                    created: {
                                        # Check for events created in the last 24 hours.
                                        gte: Time.now.utc.to_i - 24 * 60 * 60,
                                    },
                                })

    events.auto_paging_each do |event|
      session = event['data']['object']
      if session.client_reference_id.to_i == @contest.id
        @contest.paid_for = true
        @contest.save
        flash[:notice] = 'Funds successfully deposited for Contest.'
      end
    end
  end


end
