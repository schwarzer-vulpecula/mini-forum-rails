class RepliesController < ApplicationController
  before_action :set_reply, only: %i[ edit update destroy ]
  before_action :require_permission, only: %i[ edit update destroy ]

  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  def create
    @reply = current_user.replies.new(reply_params)

    respond_to do |format|
      if @reply.save
        @reply.comment.post.touch_recent
        Notification.user_replied_to_comment(current_user, @reply, @reply.comment)
        format.html { redirect_to @reply.comment, notice: "Reply was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply.comment, notice: "Reply was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to @reply.comment, notice: "Reply was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reply_params
      params.require(:reply).permit(:content, :comment_id)
    end

    def require_permission
      unless higher_rank?(@reply.user)
        unauthorized_redirect_to @reply.comment
      end
    end
end
