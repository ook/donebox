class UsersController < ApplicationController
  layout 'login'

  def new
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    
    redirect_to home_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

end
