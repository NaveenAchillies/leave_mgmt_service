class LeaveEventsController < ApplicationController
  before_action :set_leave_event, only: [:show, :edit, :update, :destroy]

  # GET /leave_events
  # GET /leave_events.json
  def index
    if Rails.cache.read('leave_events').present?
      @leave_events = Rails.cache.read('leave_events')
    else
      @leave_events = LeaveEvent.all.as_json(:methods=>[:email])
      Rails.cache.write("leave_events",@leave_events)
    end
  end

  # GET /leave_events/1
  # GET /leave_events/1.json
  def show
  end

  # GET /leave_events/new
  def new
    @leave_event = LeaveEvent.new
  end

  # GET /leave_events/1/edit
  def edit
  end

  # POST /leave_events
  # POST /leave_events.json
  def create
    @leave_event = LeaveEvent.new(leave_event_params.permit!)
    respond_to do |format|
      if @leave_event.save
        format.html { redirect_to leave_events_path, notice: 'Leave event was successfully created.' }
        format.json { render :show, status: :created, location: @leave_event }
      else
        format.html { render :new }
        format.json { render json: @leave_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leave_events/1
  # PATCH/PUT /leave_events/1.json
  def update
    respond_to do |format|
      if @leave_event.update(:status=>leave_event_params[:status].to_i)
        format.html { redirect_to @leave_event, notice: 'Leave event was successfully updated.' }
        format.json { render :show, status: :ok, location: @leave_event }
      else
        format.html { render :edit }
        format.json { render json: @leave_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_events/1
  # DELETE /leave_events/1.json
  def destroy
    @leave_event.destroy
    respond_to do |format|
      format.html { redirect_to leave_events_url, notice: 'Leave event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave_event
      @leave_event = LeaveEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_event_params
      params.fetch(:leave_event, {})
    end
end
