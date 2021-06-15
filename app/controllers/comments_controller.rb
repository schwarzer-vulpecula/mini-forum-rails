class CommentsController < ApplicationController
  skip_before_action :require_login, only: %i[ show ]
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :require_permission, only: %i[ edit update destroy ]

  # GET /comments/1
  def show
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = current_user.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        @comment.post.touch_recent
        format.html { redirect_to @comment.post, notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.post, notice: "Comment was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      sanitize params.require(:comment).permit(:content, :post_id)
    end

    def require_permission
      unless higher_rank?(@comment.user)
        unauthorized_redirect_to @comment
      end
    end
end
