---

layout: default

title: Users

---

## Table of Contents
- [Basic Information](./)
- [Static Pages](./static-pages)
- [Routing](./routing)
- [Users](./users)
  - [Password Hashing and Authentication](#password-hashing-and-authentication)
  - [Changing Passwords](#changing-passwords)
  - [Current Password For Confirmation](#current-password-for-confirmation)
- [Sessions](./sessions)
- [Posts](./posts)
- [Comments and Replies](./comments-replies)
- [Notifications](./notifications)
- [Common Features](./common-features)
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Users

The user is the most important resource. A lot of attention was given for the security of users in **mini-forum-rails**. Although many of the things I did here were already done before by many other developers, I decided that I would like to do this on my own for the sake of learning and understanding the concept.

## Password Hashing and Authentication

Passwords should never be stored in plain text. Password digests with their salt is commonly accepted to be a safer way of storing them. This means that before a User record is added to be database, some extra steps need to be taken. The password input should be hashed with a randomly generated salt before updating the database with the record. Similarly, authentication means replicating the steps to create a digest to compare with the one in the database. This can be done using modules found in the Ruby Standard Library, namely `SecureRandom` and `Digest`.

```ruby
# app/models/user.rb

require 'securerandom'
require 'digest'

class User < ApplicationRecord
  before_save :hash_password, if: -> { self.salt.nil? }

  # Authenticates the password included with the password of this user
  def authenticate(password)
    password << self.salt
    password = Digest::SHA256.hexdigest password
    if password == self.password
      true
    else
      false
    end
  end

  private
    def hash_password
      self.salt = SecureRandom.alphanumeric(16)
      self.password << self.salt
      self.password = Digest::SHA256.hexdigest self.password
    end
end
```

The `if: -> { self.salt.nil? }` condition is there to prevent hashing the password over and over with a new salt. The only time the salt is ever nil is if the user record is new, which means we require a new salt value, or the controller specifically requests it to be nil based on certain conditions. The end user cannot set a salt manually because it is not a permitted parameter. This is important for another feature that I will be covering in the next section.

```ruby
# app/controller/users_controller.rb
# Notice how :salt is not included in the permit
class UsersController < ApplicationController
  private
    # Only allow a list of trusted parameters through.
    def user_params
      sanitize params.require(:user).permit(:username, :password, :password_confirmation, :display_name, :about_me, :avatar, :current_password, :banned, :ban_message)
    end
end
```

## Changing Passwords

Many web applications allow users to leave the password change fields empty, if a user does not want to change their password. Unfortunately, due to how Rails work, this is not very straightforward thing to do. Leaving it empty will cause existing validations for the password to fail, because Rails believe the user is trying to make their password empty (And empty passwords are bad!). This is where the the nil salt value becomes important.

In the `UserController`, a special filter is run through each time update is called. The filter will check for when the password fields are empty, and if it is, it will specifically tell rails to not attempt to update the password. If the password fields are not empty, it means the user is trying to change their password, so we also add an additional request for a new salt since there has been a change. 

```ruby
class UsersController < ApplicationController
  private
    # Complex filter for updating a user for security reasons
    def update_filter(params)
      filtered_params = params
      # If either the password or confirmation is empty (Excluding whitespaces), or the current user is not allowed to change the password of this user...
      if ((filtered_params[:password].nil? || filtered_params[:password].length == 0) && (filtered_params[:password_confirmation].nil? || filtered_params[:password_confirmation].length == 0)) || !allow_password_change?(@user)
      # Do not attempt to update the password; remove it from the hash
        filtered_params.delete(:password)
        filtered_params.delete(:password_confirmation)
      else
        # Request to clear the salt so that a new one will be given
        filtered_params[:salt] = nil
      end
      filtered_params.delete(:username) unless allow_username_change?(@user)
      filtered_params.delete(:banned) unless allow_user_ban?(@user)
      filtered_params.delete(:ban_message) unless allow_user_ban?(@user)
      filtered_params[:current_user] = current_user # Save the current user for validation by the User model
      filtered_params
    end
end
```

Below is a GIF showcasing this functionality.

![Password Changing](./password-changing.gif)

## Current Password For Confirmation

Often, when editing your profile, you are required to include your current password to save your changes. This is an additional step typically needed for security. I have also implemented this in **mini-forum-rails**. This is a very important feature because mods and admins in **mini-forum-rails** are allowed to change other users, and requiring this is an additional layer of security.

We need to be able to pass the current password for authentication through the same form used in updating the user. However, this field is not part of the User model, and should not be saved to the database as it is only used for authentication. This is known in Rails as a virtual attribute. A custom validation is also needed to authenticate this.

```ruby
class User < ApplicationRecord
  attr_accessor :current_user
  attr_accessor :current_password
  validate :current_password_for_edit

  private
    def current_password_for_edit
      # This validation is needed to ensure that the one editing (ie. The one behind the screen) is indeed the same person as the one signed in
      if !self.new_record?
        errors.add(:current_password, "is incorrect") unless current_user.authenticate(current_password)
      end
    end
end
```

Notice how I have also passed the current user as a virtual attribute for authentication. This is because the user being updated is not necessarily the current signed in user. As mentioned earlier, mods and admins are allowed to modify other users. The authentication checks the password inputted with the password of the signed in user, not the password of the user being updated (How would they be able to modify otherwise?).
