class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy mute ]
  before_action :require_permission, only: %i[ edit update destroy ]
  before_action :require_personal,  only: %i[ mute ]

  # GET /posts
  def index
    params[:search] = params[:search].squish unless params[:search].nil?
    @posts = Post.search(params[:search])
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.new(post_params.except(:notify_users))

    respond_to do |format|
      if @post.save
        @post.touch_recent
        Notification.staff_posted_announcement(current_user, @post) if current_user.staff? && params[:post][:notify_users] == '1'
        format.html { redirect_to @post, notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
    end
  end

  # POST /posts/1/mute
  def mute
    @post.mute = !@post.mute
    @post.save(touch: false)
    redirect_to @post, notice: "Notifications about this post was successfully #{@post.mute ? 'muted' : 'unmuted'}."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      sanitize params.require(:post).permit(:title, :content, :notify_users)
    end

    def require_permission
      unless higher_rank?(@post.user)
        unauthorized_redirect_to @post
      end
    end

    def require_personal
      unless current_user == @post.user
        unauthorized_redirect_to @post
      end
    end
end
