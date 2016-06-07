class ContentsController < ApplicationController
  before_action :load_content, only: %i(show edit update destroy)

  def search
    @contents_search = Search::Content.new(search_params)
    @contents = @contents_search
      .matches
      .order(availability: :desc, code: :asc)
      .decorate
  end

  # GET /contents
  # GET /contents.json
  def index
    @contents_search = Search::Content.new
    #@contents = IticketContent.all.concat(MedicalContent.all)
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content tag was successfully created.' }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Content tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: 'Content tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
 
  def load_content
    @content = content_class.find(params[:id])
  end
 
  def type
    params[:type]
  end
 
  def content_params
    params.require(type.underscore.to_sym).permit(:name, :url, :thumbnail_url, :playing_sec, :validity_start_date, :validity_end_date, :enabled)
  end
 
  def content_class
    type.constantize
  end

  # 検索フォームから受け取ったパラメータ
  def search_params
    params
      .require(:search_content)
      .permit(Search::Content::ATTRIBUTES)
  end
end
