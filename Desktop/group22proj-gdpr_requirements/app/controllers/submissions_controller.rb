class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:destroy, :index]
  before_action :set_contest, only: [:new, :create]
  before_action :authenticate_user!


  # GET /submissions
  # GET /submissions.json
  def index
    @contest = Contest.find_by(id: params[:contest_id])
    @submissions = Submission.all.where(contest_id: @contest.id).order("created_at")
    @user_submission = Submission.where(contest_id: @contest.id, user_id: current_user.id)
  end

  # GET /submissions/new
  def new
    @submission = @contest.submissions.new
    @submission.user = current_user

    user_submission = Submission.where(contest_id: @contest.id, user_id: @submission.user.id)
    respond_to do |format|
      if !user_submission.empty?
        format.html { redirect_to contests_path, alert: 'You are already entered into this contest. Please delete your current submission in View Entries page to upload a different submission.' }
      elsif @contest.is_student_only && !@submission.user.is_student
        format.html { redirect_to contests_path, alert: 'Only students are allowed to enter this contest.' }
      elsif @submission.user.stripe_id.nil?
        format.html { redirect_to contests_path, alert: 'You must connect your Stripe account before entering a contest.' }
      else
        format.html { render :new }
      end
    end
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = @contest.submissions.new(submission_params)
    @submission.user = current_user
    user_submission = Submission.where(contest_id: @contest.id, user_id: @submission.user.id)
    respond_to do |format|
      if user_submission.empty?
        if @submission.save
          @submission.user.contests_entered += 1
          @submission.user.save
          format.html { redirect_to contest_submissions_path, notice: 'Your submission has been successfully uploaded to this contest.' }
        end
      else
        format.html { redirect_to contests_path, alert: 'You are already entered into this contest!' }
      end
    end
  end

  # # PATCH/PUT /submissions/1
  # # PATCH/PUT /submissions/1.json
  # def update
  #   respond_to do |format|
  #     if @submission.update(submission_params)
  #       format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
  #     else
  #       format.html { render :edit }
  #     end
  #   end
  # end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @contest = @submission.contest
    @submission.user = current_user
    respond_to do |format|
      if @contest.has_ended
        format.html { redirect_to contest_submissions_path, alert: 'You cannot remove your submission after a contest has ended.' }
      else
        @submission.destroy
        @submission.user.contests_entered -= 1
        @submission.user.save
        format.html { redirect_to contest_submissions_path, notice: 'You have successfully removed your submission from this contest.' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.find_by(id: params[:id])
  end

  def set_contest
    @contest = Contest.find_by(id: params[:contest_id]) || Contest.find(submission_params[:contest_id])
  end

  # Only allow a list of trusted parameters through.
  def submission_params
    params.require(:submission).permit(:contest_id, :user_id, :attachment)
  end
end
