---

layout: default

title: Routing

---

## Table of Contents
- [Basic Information](./)
- [Static Pages](./static-pages)
- [Routing](./routing)
- [Users](./users)
- [Sessions](./sessions)
- [Posts](./posts)
- [Comments and Replies](./comments-replies)
- [Notifications](./notifications)
- [Common Features](./common-features)
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Routing

For routing, I decided that each resource should be on its own. This is because I decided that replies and comments should be considered a different model even though functionally they are very similar. When I designed the application, I thought comments should not be infinitely recursive, as it sometimes gets confusing for the users. The best way of doing this is to have the comments of comments be a new model, the reply. This is detailed in the [comments and replies](./comments-replies) section.

With this design in mind, initially it made sense to have nested resources. Nesting comments within posts, and then replies within comments, made the most sense. However, this means resources are nested 2 levels deep. The router helpers ended up being very confusing. In fact, it is commonly accepted by Rails developers that resources should not be nested more than 1 level deep. In the end, I decided that each resource should indeed be on its own.

```ruby
# config/routes.rb
# Only resource routes are shown
Rails.application.routes.draw do
  resources :users
  resources :posts
  resources :comments, except: [:index, :new]
  resources :replies, except: [:index, :show, :new]
  resources :notifications, only: [:index, :destroy]
end
```

Although this does mean the end user will not be able to see a comment's parent post in the URL, Rails will still keep the association, so the view can easily convey this association across by providing links that lead back to the parent post.
