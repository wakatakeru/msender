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

    document_title = document.title.to_s
    document_body  = document.content.to_s
    before_is_send = document.is_send
    document.is_send = true
    
    if current_user.is_admin
      if document.save && before_is_send == false
        MailerMailer.send_minutes(document_title, document_body).deliver
        flash['info'] = "メール #{document_title} を送信しました"
        @document = document
        render 'show' and return
      else
        flash['danger'] = "メール #{document_title} の送信に失敗しました"
        @document = document
        render 'show' and return
      end
    else
      flash['danger'] = "メールの送信権限がありません"
      @document = document
      @document.is_send = false
      render 'show' and return
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
