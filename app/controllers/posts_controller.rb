class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :require_permission, only: %i[ edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      filtered_params = params.require(:post).permit(:title, :content)
      filtered_params.each_key do |k|
        # Squish all user inputs
        if k == 'content'
          # Squish each individual lines instead
          content_array = filtered_params[k].split("\n")
          for i in 0...content_array.length
            content_array[i] = content_array[i].squish
          end
          # Rejoin the lines into one
          filtered_params[k] = content_array.reject(&:blank?).join("\n")
        else
          filtered_params[k] = filtered_params[k].squish
        end
      end
      return filtered_params
    end

    def require_permission
      unless authorized?(@post.user)
        unauthorized_redirect_to @post
      end
    end
end
