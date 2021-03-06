class UsersController < ApplicationController
    before_action :can_create_users, only: [:new, :create]
    # before_action :verify_self, only: [:update, :edit]

    def index
        users
    end

    def new        
        @user = User.new
        @permissions = @current_user.vendor.permission_classes
    end

    def create
        @permissions = @current_user.vendor.permission_classes
        @user = User.new(user_params.merge(vendor: @current_user.vendor))
        return  render :new unless @user.save
        redirect_to users_path
    end

    def show        
        @user = User.find(params[:id])
        return redirect_to users_path unless @user.vendor == current_user.vendor  
        @gigs = @user.technician_bookings.order(:call_time)        
    end

    def edit
        @user = User.find(params[:id])
        return redirect_to users_path unless @user.vendor == current_user.vendor
        @permissions = @user.vendor.permission_classes  
    end

    def update
        if params[:id] == 'set_title'
            user = User.find(permission_params[:id])
            user.update_attribute(:permission_class_id, permission_params[:permission_class_id])
            return render permission_classes_path
        end
        @user = User.find(params[:id])
        @permissions = @user.vendor.permission_classes
        return render :edit unless @user.update(user_params)
        redirect_to user_path(@user)
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path
    end  

    private
    
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :password, :password_confirmation, :permission_class_id)
    end

    def permission_params
        params.require(:user).permit(:permission_class_id, :id)
    end

    def can_create_users
        if !current_user.permission_class.create_users
        flash[:alert] = "You dont have permission to create users"
        return redirect_to request.referrer unless request.referrer == nil
        redirect_to '/'
        end
      end

end
