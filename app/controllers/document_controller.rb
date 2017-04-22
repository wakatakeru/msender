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
    document.is_send   = false
    
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
    document.is_send = params['document']['is_send']
    
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

  def send_mail
    document = Document.find(params['id'].to_i)

    if document.is_send
      flash['danger'] = 'このメールは送信済みです'
      redirect_to document_index_path
    end

    document_title = document.title.to_s
    document_body  = document.content.to_s
    document.is_send = true

    if document.save == false
      flash['danger'] = "メール #{document_title} の送信に失敗しました"
      redirect_to document_index_path and return
    end
    
    if MailerMailer.send_minutes(document_title, document_body).deliver
      flash['info'] = "メール #{document_title} を送信しました"
      redirect_to document_index_path and return
    else
      flash['danger'] = "メール #{document_title} の送信に失敗しました"
      redirect_to document_index_path and return
    end
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
