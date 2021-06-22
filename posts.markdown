---

layout: default

title: Posts

---

## Table of Contents
- [Basic Information](./)
- [Static Pages](./static-pages)
- [Routing](./routing)
- [Users](./users)
- [Sessions](./sessions)
- [Posts](./posts)
  - [Recent Activity](#recent-activity)
  - [Input For Notifying Users](#input-for-notifying-users)
- [Comments and Replies](./comments-replies)
- [Notifications](./notifications)
- [Common Features](./common-features)
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Posts

A post is one of the more simpler model in **mini-forum-rails**, only being slightly more complex than comments and replies. The most important part of the `Post` model is done by Rails. Little to no work was done to achieve this functionality. However, there were several things that require special attention, although they are mainly secondary functions.

## Recent Activity

A timestamp that shows when a user has recently created a new comment or a new reply inside a post is a common feature. Other users can then see how active a post is, even if it was posted a long time ago.

Since posts can be edited at any time, the `updated_at` timestamp is already used to keep track of when a post's content was last modified. So a new timestamp should be added to posts. The modification of this timestamp should also not change the `updated_at` timestamp, and Rails must be specifically told to not do so as the change is a default behaviour that happens every time an attribute was modified.

```ruby
# app/models/posts.rb
class Post < ApplicationRecord
=begin
  Tells the post to update its recent_activity value with the current time.
  Because the update_at is supposed to represent when the post's content is actually updated,
  this need to be done differently.
=end
  def touch_recent
    self.recent_activity = Time.now
    self.save(touch: false)
  end
```

`touch_recent` can then be called at relevant points in the controllers when a post needs to have this timestamp updated. For example, the `CommentsController` will call this after a new comment was successfully created inside the post.

```ruby
# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        @comment.post.touch_recent
        Notification.user_commented_on_post(current_user, @comment, @comment.post)
        format.html { redirect_to @comment.post, notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
end
```

It should be noted that there is no other way to modify the `recent_activity` timestamp, and that `touch_recent` is the only method that can modify it. This enforces the way the timestamp works.

## Input For Notifying Users

Moderators and Administrators have the ability to notify everyone when a post by them is created. Passing this parameter to the server is not a difficult task, but how to handle it is not as straightforward. Since this parameter should not be part of the `Post` model, it should not be saved to the database.

Initially, it made sense to make this parameter virtual inside the `Post` model. We can then create the appropriate notifications if the parameter is set to true. However, this is a strange way of doing things as `Post` models should not be able to create `Notification` models. They should not even reference each other in the first place!

Passing the parameter as a virtual attribute is not inherently wrong, but the resolution of the parameter should not happen in the model. The better solution would be to call the virtual attribute from the controller, and then resolve it there. However, this is very roundabout.

I believe the best solution would be to exclude the parameter from entering the `User` model in the first place. Unfortunately, this does mean the controller has to deal with the parameter in raw form, meaning even though this should logically be boolean, it is actually passed as a string from the form, and code becomes less readable when handling this.

```ruby
# app/controller/posts_controller.rb
# Notice how I specifically excluded the notify_users parameter from being passed
class PostsController < ApplicationController
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

  private
    # Only allow a list of trusted parameters through.
    def post_params
      sanitize params.require(:post).permit(:title, :content, :notify_users)
    end
end
```

Actual notification creation is handled by the `Notification` model. For more information on how this works, see the [notifications](./notifications) section.
