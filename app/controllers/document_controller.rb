# coding: utf-8
class DocumentController < ApplicationController

  before_action :login_check

  def index
    @documents = Document.search(:title_cont => params[:q]).result
  end

  def show
    @document = Document.find(params['id'])
  end
  
  def new
    @document = Document.new
  end

  def create
    document = Document.new
    
    document.title     = params['document']['title']
    document.content   = params['document']['content']
    document.user      = current_user
    
    if document.save
      flash[:success] = "ドキュメントを保存しました"
      redirect_to document_index_path
    else
      @document = Document.new
      @document.title   = params['document']['title']
      @document.content = params['document']['content']
      flash[:danger]  = "タイトルが空です。保存できません"
      render 'new'
    end
  end

  def edit
    @document = Document.find(params['id'])
  end

  def update
    document = Document.find(params['id'])
    
    document.title   = params['document']['title']
    document.content = params['document']['content']
    
    if document.save
      flash[:success] = "ドキュメントの更新に成功しました"
      redirect_to document_index_path
    else
      @document = Document.new
      @document.title   = params['document']['title']
      @document.content = params['document']['content']
      flash[:danger] = "タイトルが空です。保存できません。"
      redirect_to edit_document_path(params['id'])
    end
  end

  def download

  end
  
  def destroy
    document = Document.find(params['id'])

    if document.destroy
      flash[:success] = "ドキュメントの削除に成功しました"
      redirect_to document_index_path
    else
      flash[:danger] = "ドキュメントの削除に失敗しました"
      redirect_to document_index_path
    end
  end

  private
  
  def login_check
    redirect_to login_path unless is_login
  end
end
