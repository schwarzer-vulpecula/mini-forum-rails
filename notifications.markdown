---

layout: default

title: Notifications

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
  - [Structure](#structure)
  - [Creation](#creation)
- [Common Features](./common-features)
- [Live Application](./live)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Notifications

Notifications are important for any forum user. A forum would feel incomplete without it. Many things were considered for notifications during the development of **mini-forum-rails**.

## Structure

Keeping track of notifications in the database can be difficult without a proper structure. The variability of the content and associations of notifications can pose a problem for relational databases. A user can be notified by several different sources about various topics, and the database needs to be structured properly to accomodate this.

It makes sense to have an `event` attribute that will keep track of what the notification is supposed to be about. This was done using enums in **mini-forum-rails**.

Meanwhile, the content of the notification is normally a sentence that contains links to relevant entities. In **mini-forum-rails**, the notification contains 3 attributes, a `subject`, a `verb` and an `object`. These attributes are not associated with anything, and are simply integers. However, they are meant to represent the IDs of the relevant entities. The downside to this approach is that the database is not able to enforce anything, however, the upside to this approach is that notifications are very flexible and powerful when properly used by the application.

Alternatively, we could have a different model for every different type of notification, and it will be easily enforced. However, this can be very tedious to do, and it is most likely not very scalable. The database will also quickly become very cumbersome to maintain. This is why I am against this approach. The flexibility outweighs the lack of enforcement.

```ruby
# db/migrations/20210616080021_create_notifications.rb
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event, null: false
      t.integer :subject
      t.integer :verb
      t.integer :object
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
```

```ruby
# app/model/notifications.rb
class Notification < ApplicationRecord
  enum event: { 'user_commented_on_post' => 0, 'user_replied_to_comment' => 1, 'staff_posted_announcement' => 2 }
end
```

The `event` attribute can then be used to determine the actual content. View partials can be easily associated with this value.

```erb
<!-- app/views/notifications/index.html.erb -->
<h1>Notifications</h1>
<h3><%= link_to 'Destroy All', notifications_path, method: :delete, data: { confirm: 'Are you sure?' } %></h3>
<table>
  <thead>
    <tr>
      <th>Time</th>
      <th>Event</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @notifications.order("created_at desc").each do |notification| %>
      <tr>
        <td><b><%= 'New! ' unless notification.read %></b><%= time_ago_in_words notification.created_at %> ago</td>
        <td><%= render notification.event, notification: notification%></td>
        <td><%= link_to 'Destroy', notification, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

`render notification.event` will resolve to rendering a partial named after the `event` attribute. For example, if the notification is about a user commenting on a post, `_user_commented_on_post.html.erb` will be rendered. Each view partial can put links based on the `subject`, `verb`, and `object` attributes. `subject` is typically the user who caused the event, `verb` is typically a link to a what the `subject` has done, which is the comment in this case, and `object` is typically the receiver of the action, which is the post in this case.

```erb
<!-- app/views/notifications/_user_commented_on_post.html.erb -->
<% user = User.find_by(id: notification.subject) -%>
<% comment = Comment.find_by(id: notification.verb) -%>
<% post = Post.find_by(id: notification.object) -%>
<% if !user.nil? -%>
  <%= user.rank_name %> <%= link_to user.name, user %>
<% else -%>
  A deleted user
<% end -%>
commented
<% if !comment.nil? && !post.nil? -%>
  on your post titled <%= link_to post.title, post_path(post, anchor: comment.id) %>
<% elsif comment.nil? && !post.nil? -%>
  (Now Deleted) on your post titled <%= link_to post.title, post_path(post) %>
<% else %>
  on your post (Now Deleted)
<% end -%>
```

This means every event can have its own view partial which will render the content specifically for them.

![Various Notifications](./various-notifications.png)

## Creation
