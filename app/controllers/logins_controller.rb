class LoginsController < ApplicationController
  def show
    render 'new'
  end

  def create
    user = User.find_by(:login_id => params[:login_id])
    if user && user.authenticate(params[:password])
      session[:login_id] = user.id
      flash[:success] = "ログインに成功しました"
      redirect_to root_index_path
    else
      flash[:danger] = "ログインに失敗しました"
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
