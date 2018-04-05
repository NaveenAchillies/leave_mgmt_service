class LeavePeroidsController < ApplicationController
  before_action :authenticate_admin

  def index
    if $redis.get("leave_peroids").present?
      @leave_peroids = JSON.parse($redis.get("leave_peroids"))
    else
      @leave_peroids = LeavePeroid.all
      $redis.set("leave_peroids",@leave_peroids.to_json)
    end
  end

  def new
    @leave_peroid = LeavePeroid.new
  end

  def create
    @leave_peroid = LeavePeroid.new(leave_peroid_params.permit(:user_id,:assigned))
    respond_to do |format|
      if @leave_peroid.save
        format.html { redirect_to leave_peroids_path, notice: 'LeavePeroid was successfully created.' }
        format.json { render :show, status: :created, location: @leave_peroids }
      else
        format.html { render :new }
        format.json { render json: @leave_peroid.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def authenticate_admin
      unauthorized  unless Thread.current[:current_user].role == "admin"
    end

    def unauthorized
      redirect_to root_path ,:status => :unauthorized
    end

    def leave_peroid_params
      params.fetch(:leave_peroid, {})
    end
end
