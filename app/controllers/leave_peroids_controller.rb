class LeavePeroidsController < ApplicationController
  before_action :authenticate_admin

  def index
    key = "leave_peroids_" + Thread.current[:current_act_id].to_s
    if Rails.cache.read(key)
      @leave_peroids = Rails.cache.read(key)
    else
      @leave_peroids = LeavePeroid.all.as_json(:methods=>[:email])
      Rails.cache.write(key,@leave_peroids)
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
