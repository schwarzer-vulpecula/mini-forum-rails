class RepliesController < ApplicationController
  before_action :set_reply, except: %i[ create ]
  before_action :require_permission, except: %i[ create ]

  # GET /replies/1/edit
  def edit
  end

  # POST /replies or /replies.json
  def create
    @reply = current_user.replies.new(reply_params)

    respond_to do |format|
      if @reply.save
        format.html { redirect_to @reply.comment, notice: "Reply was successfully created." }
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { redirect_to @reply.comment, alert: "Reply cannot be empty." }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1 or /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply.comment, notice: "Reply was successfully updated." }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1 or /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to replies_url, notice: "Reply was successfully destroyed." }
      format.json { head :no_content }
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
      unless authorized?(@reply.user)
        unauthorized_redirect_to @reply.comment
      end
    end
end
