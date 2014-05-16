class Admin::UsersController < Admin::ApplicationController
  respond_to :html

  def index
    @users = admin_policy_scope(User).page(params[:page])
  end

  def show
    @user = User.find(params[:id])

    admin_authorize @user
  end
end