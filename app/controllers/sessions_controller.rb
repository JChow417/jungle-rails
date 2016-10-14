class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      redirect_to '/'
    else
    # If user's login doesn't work, send them back to the login form.
      @messages = []
      if user
        @messages << "Incorrect Password" if params[:password].length != 0
      else
        @messages << "User does not exist" if params[:email].length != 0
      end

      @messages << "Email is blank" if params[:email].length == 0
      @messages << "Password is blank" if params[:password].length == 0

      render :new
      # redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
