class RootController < ApplicationController

  before_action :login_check

  def index
    @documents = Document.search(
      :title_cont      => params[:title_q],
      :content_cont    => params[:content_q]
    ).result

    @count = @documents.count
  end
  
  def login_check
    redirect_to login_path unless is_login
  end
end
