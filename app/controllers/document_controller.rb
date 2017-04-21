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
    @tags = Tag.all
  end

  def create
    document = Document.new
    
    document.title     = params['document']['title']
    document.content   = params['document']['content']
    
    if params['document']['tag_id']
      document.tag_id  = params['document']['tag_id']
    else
      document.tag_id  = Tag.first.id
    end

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
    if params['document']['tag_id']
      document.tag_id  = params['document']['tag_id']
    else
      document.tag_id  = Tag.first.id
    end

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
    document = Document.find(params['id'].to_i)
    title = document.title
    out = Prawn::Document.new(:page_size => 'A4') do
      font "app/assets/fonts/light.ttf"
      
      draw_text "#{document.title}" ,
                :size => 20, :at => [30, 740]
      stroke_color 'A4A4A4'
      stroke_horizontal_line 0, 540, :at=> 730

      font "app/assets/fonts/regular.ttf"
      
      text_box "#{document.content}" ,
               :size => 10, :at => [30, 700], :width => 470, :height => 680
    end

    send_data(out.render, :filename => "#{document.title}.pdf")
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
