class SessionsController < ApplicationController
    before_action :require_login, only: [:index, :home, :destroy]
  
    def index
    end    

    def login
    end

    def create
      user = User.find_by(username: params[:user][:username])
      return redirect_to '/login' unless user.try(:authenticate, params[:user][:password])   
      session[:user_id] = user.id
      redirect_to '/'
    end
  
    def destroy
      session.delete :user_id  
      redirect_to '/'
    end


end