class ApplicationController < ActionController::Base
    before_action :current_user, :require_login

    def current_user
      @user = (User.find_by(id: session[:user_id]) || User.new)      
    end
  
    def logged_in
      current_user.id != nil
    end
  
    def require_login
      return redirect_to login_path unless logged_in
    end
end
