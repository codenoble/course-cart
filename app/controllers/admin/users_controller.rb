class Admin::UsersController < Admin::ApplicationController
  respond_to :html

  def index
    @users = policy_scope([:admin, User])
    @users = @users.with_role(params[:role]) if params[:role]
    @users = @users.page(params[:page])
  end

  def show
    @user = User.find(params[:id])

    authorize [:admin, @user]
  end
end
