class CommentsController < ApplicationController
  before_filter :authenticate_user!, except:  [:index, :show]
  before_filter :get_parent
  load_and_authorize_resource
  def new
    @comment = @parent.comments.build
  end
  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_url(@comment.article), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to article_url(@comment.article), notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to article_url(@comment.article) }
      format.json { head :no_content }
    end
  end
end


def get_parent
  @parent = Article.find_by_id(params[:article_id]) if params[:article_id]
  @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]

  redirect_to root_path unless defined?(@parent)
end

