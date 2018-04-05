class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_thread, :authenticate_user!
  	def current_thread
		Thread.current[:current_user] = current_user if current_user.present?
	end
end
