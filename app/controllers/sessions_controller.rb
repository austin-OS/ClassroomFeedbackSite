class SessionsController < ApplicationController
  include SessionsHelper

  def new; end

  # Logging in
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      login user
      redirect_to home_url
    else
      flash.now[:danger] = 'Email and password combination not found'
      render 'new', status: :unprocessable_entity
    end
  end

  # Logging out
  def destroy
    logout
    redirect_to root_url, status: :see_other
  end
end
