---

layout: default

title: Basic Information

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

# Static Pages

In truth, the static pages in **mini-forum-rails** is not actually static. For a better User Experience, it is usually recommended to keep a similar layout between pages. Most layouts are dynamic as it typically changes based on login information. In Rails, this means the static page should not be part of the asset pipeline, but should instead be part of the view.

Since it is part of the view, there has to be a controller for static pages, the `HomeController` class. Technically, the content of the static page is the model, and the controller's job is to take information from the model, render it as defined by the view, and pass it back to the browser, but this not the way it was done in **mini-forum-rails**. The `HomeController` essentially does nothing while the view has all the content.

```ruby
# home_controller.rb
class HomeController < ApplicationController
  skip_before_action :require_login

  def index
  end

end
```

```ruby
# home/index.html.erb
<h1>Welcome to Mini Forum!</h1>

<p>Welcome to my humble website, written in Ruby on Rails 6.1.3.2.
<br>Please remember to be nice to each other and never post illegal content.
<br>I am not sure what else to write here to be honest.
<br>This is just placeholder text anyway.
<br>Have fun and enjoy your stay!
</p>
```

However, Rails automatically assigns the correct layout to this view, so the proper headers and footers will be there. Also, should there be a need for additional static pages that require layout, all you need to do is add an empty action in the controller, and add a route to it.

![Home Page](./home-page.png)

As you can see, the headers were added along with the content. Just exactly how it should be.

Although this method does not follow the proper MVC pattern, I believe this is the most simplest way of making this work the way it should. There is no need for a separate model when the content is static.
