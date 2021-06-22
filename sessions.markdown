---

layout: default

title: Sessions

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
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Sessions

While the `User` model holds data relating to users, sessions is what gives people the ability to sign in as users. In **mini-forum-rails**, sessions are controlled by a `SessionsController`, and the signing in and out of users are handled by this controller. Many of the things an end user is able to do is defined by the session.

## Privileges

The session should always restrict the end user in some way or form in the context of **mini-forum-rails**. For example, creating a new post requires you to be signed in, since the application does not allow anonymous posting. Also, users should not be able to edit other users or their posts, unless they have special privileges, which is based on their rank (ie. Moderator or Administrator). While the `User` model keeps track of the rank, the session is the one enforcing the rules. The `SessionsHelper` module contains methods that are used when responding to a request.

Since there are many pages that require the user to be signed in, it makes sense to put the validation in the `ApplicationController`, which will mean all controllers will require the user to be signed in by default.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  before_action :require_login

  private
    def require_login
      unless signed_in?
        flash[:alert] = "You must be signed in to do that."
        redirect_to login_url
      end
    end
end
```

This validation is skipped on specific controller actions individually. For example, since viewing a post should not require the user to be signed in, the `PostController` has a specific line for it. By doing this, we can ensure that there is a level of security maintained. Additionally, more validations can be run before a user is allowed to do more sensitive actions like edit, update, or destroy.

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[ index show ]
  before_action :require_permission, only: %i[ edit update destroy ]
  before_action :require_personal,  only: %i[ mute ]

  private
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
```

Methods like `current_user`, `higher_rank?`, and `signed_in?` are part of the `SessionsHelper` module. This module also contains very specific validations, such as when to allow the current session to be able to change a specific user's password or not, which may require case by case checks.

```ruby
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Sign in the given user
  def sign_in(user)
    session[:user_id] = user.id
  end

  # Sign out the current user
  def sign_out
    @current_user = nil
    session[:user_id] = nil
  end

  # Saves the user stored in sessions in @current_user
  # Sign the user out immediately if the user is banned
  # Then return it
  def current_user
    @current_user = User.find_by(id: session[:user_id]) if @current_user.nil?
    sign_out if !@current_user.nil? && @current_user.banned
    @current_user
  end

  # Returns true if current session is storing a user
  def signed_in?
    !current_user.nil?
  end

  # Returns true if current user is higher rank than the object's owner, or current user is the same user as the object's owner
  def higher_rank?(object)
    return false unless signed_in?
    if object.is_a?(User)
      current_user == object || current_user.rank_before_type_cast > object.rank_before_type_cast
    else
      current_user == object.user || current_user.rank_before_type_cast > object.user.rank_before_type_cast
    end
  end

  # Returns true if current user should be allowed to modify the username of the given user
  def allow_username_change?(user)
    return true if user.new_record?
    return false unless signed_in?
    current_user.rank == 'administrator'
  end

  # Similar to the above, but for passwords
  def allow_password_change?(user)
    return true if user.new_record?
    return false unless signed_in?
    current_user == user
  end

  # Returns true if current user should be allowed to destroy the given user
  def allow_user_destroy?(user)
    # For now, nobody can destroy users as it is rather destructive
    return false
  end

  # Returns true if current user can ban the given user
  def allow_user_ban?(user)
    return false unless signed_in?
    return false if current_user == user # Cannot self ban
    current_user.staff? && current_user.rank_before_type_cast > user.rank_before_type_cast
  end

end
```

Although it is strange to `return true` for `higher_rank?` when the user is the current user, I find it easier to do it this way because most things that use this validation often require the user to be able to do it on themselves as well.

Another important thing I have done here is that the session will only store `user_id`. The `current_user` method will query the database with it and then store it as a variable. It will try to not query the database every time a reference to the current user is needed. This will reduce the workload of the database.

## Redirection After Signing In

After signing in, often it makes sense to redirect the user to the last visited page. Returning to the home page after every sign in is a bad User Experience. While this task may seem straightforward, the truth is that the HTTP referer is set to the sign in page after you have sent the sign in request. This means simply redirecting to the previous page will actually bring you back to the sign in page, rather than the previous page. In **mini-forum-rails**, this is not the case.

When visiting the sign in page, the controller will immediately save the referer into the session. The user is then redirected to what was saved in the session after they have successfully signed in. However, the referer will not be saved if it refers to the sign in page. This is to prevent the previously mentioned case from happening should the user fail the initial attempt but succeeded in the next attempt.

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
    # Set url to be redirected to, unless it is the login url
    unless request.referer == login_url
      session[:referer] = request.referer
    end
  end

  def create
    # Some code here
      sign_in user
      flash[:notice] = "You have successfully signed in."
      if session[:referer] != nil
        redirect_to session[:referer]
        session[:referer] = nil
      else
        redirect_to :root
      end
    # Some more code here
  end

end
```

Below is a GIF showcasing this functionality.

![Redirection](./redirection.gif)

