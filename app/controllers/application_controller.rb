class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_thread, :authenticate_user!
  	def current_thread
  		if current_user.present?
			Thread.current[:current_user] = current_user 
			Thread.current[:current_act_id] = current_user.id
		end
	end
end
