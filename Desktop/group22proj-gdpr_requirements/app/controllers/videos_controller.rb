class VideosController < ApplicationController
  before_action :set_contest, only:[:new, :create, :destroy]

  # def live_chat
  #   # @contest = Contest.find_by(id: params[:contest_id])
  #   @videos = Video.order('DESC published_at')
  # end

  def new
    @video = @contest.videos.new
    # @video = Video.new
  end

  def create
    @video = @contest.videos.new(video_params)
    respond_to do |format|
      if @video.save
        format.html { redirect_to @contest, notice: 'Your video has been added!' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @video = Video.find_by(id: params[:id])
    @video.destroy
    respond_to do |format|
      format.html { redirect_to @contest, notice: 'Your video has been removed.' }
    end
  end


  private

  def set_video
    @video = Video.find_by(id: params[:id])
  end
  def set_contest
    @contest = Contest.find_by(id: params[:contest_id]) || Contest.find(video_params[:contest_id])
  end
  def video_params
    params.require(:video).permit(:link,:contest_id)
  end
  def submission_params
    params.require(:video).permit(:contest_id)
  end

end
