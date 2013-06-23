class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource
  #before_filter(only: [:index]) {@pages_cache = true}
  #caches_page :index
  # GET /articles
  # GET /articles.json
  def index
    if current_user
      @articles = Article.preload(:users).includes(:users).where("published_on <= ? or author_id = ? or users.id = ?", Date.today, current_user.id, current_user.id).find(:all)
    else
      @articles = Article.where("published_on <= ?", Date.today).all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @author = User.where('id =?',@article.author_id).first.username
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @users = User.all
   respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    #expire_page :action => :index
    @article.author_id = current_user.id

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    #expire_page :action => :index
    params[:article][:user_ids] ||= [] if @article.author_id == current_user.id
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    #expire_page :action => :index
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
