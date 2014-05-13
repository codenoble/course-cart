class Admin::UsersController < Admin::ApplicationController
  respond_to :html

  def index
    @users = User.all.page(params[:page])
  end

  def show
  end
end