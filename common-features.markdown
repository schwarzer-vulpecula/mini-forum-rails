---

layout: default

title: Common Features

---

## Table of Contents
- [Basic Information](./)
- [Static Pages](./static-pages)
- [Routing](./routing)
- [Users](./users)
- [Sessions](./sessions)
  - [Privileges](#privileges)
  - [Redirection After Signing In](#redirection-after-signing-in)
- [Posts](./posts)
- [Comments and Replies](./comments-replies)
- [Notifications](./notifications)
- [Common Features](./common-features)
  - [Toggling](#toggling)
  - [Searching](#searching)
  - [Input Sanitation](#input-sanitation)
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Common Features

These are some features that I would like to go over in **mini-forum-rails** which do not fit under any of the categories.

## Toggling

When an model's attribute is boolean, it sometimes make sense to have a toggle functionality to change them. Rather than going through forms, a simple button click is often much more simpler and effective. In **mini-forum-rails**, muting a post or comment is easy.

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  # POST /posts/1/mute
  def mute
    @post.mute = !@post.mute
    @post.save(touch: false)
    redirect_to @post, notice: "Notifications about this post was successfully #{@post.mute ? 'muted' : 'unmuted'}."
  end
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post 'posts/:id/mute' => 'posts#mute', :as => :post_mute
  post 'comments/:id/mute' => 'comments#mute', :as => :comment_mute
end
```

Although this is technically not RESTful, since this is deviating away from the 7 actions (index, new, create, show, edit, update, destroy), this is the most straightforward and easiest to understand solution.

Below is a GIF showing the simplicity.

![Toggling Mute](./toggling-mute.gif)

## Searching

Users, posts, and posts of specific users can all be searched. A search parameter is given to the controller, and the controller will then pass that to the models. Ultimately, the result of the query is processed by the models, rather than the controllers. This is the most effective solution. The action responsible for this is the index. However, for querying a specific user's posts, the action responsible is a custom `posts` action that is essentially an index of the specific user's posts.

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users
  def index
    params[:search] = params[:search].squish unless params[:search].nil?
    @users = User.search(params[:search])
  end

  # GET /users/1/posts
  def posts
    params[:search] = params[:search].squish unless params[:search].nil?
    @user_posts = @user.search_post(params[:search])
  end
end
```

```ruby
# app/models/user.rb
class User < ApplicationRecord

  # Returns users with a username or display name matching the search query, depending if '@' was included in the front or not
  def self.search(search)
    if search.blank?
      User.all
    elsif search.first == '@'
      User.where("username LIKE ?", "%#{search[1..-1]}%")
    else
      User.where("display_name LIKE ?", "%#{search}%")
    end
  end

  # Returns posts by this user with a title matching the search query
  def search_post(search)
    if search.blank?
      self.posts
    else
      self.posts.where("title LIKE ?", "%#{search}%")
    end
  end
end
```

Notice how the search query is sanitized using `squish` in the controller. Also notice how the search query can change depending on whether or not a special character was included (In this case, the `@` character). The search can be matched to a user's username or display name depending on input.

Below is a GIF showcasing the above functionalities.

![Searching Users](./searching-users.gif)

## Input Sanitation
