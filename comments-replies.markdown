---

layout: default

title: Comments and Replies

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

# Comments and Replies

When thinking about comments and replies, the existence of replies is dubious. A reply in the context of **mini-forum-rails** is simply a comment of a comment. Although this can be easily done using polymorphic associations, the design of **mini-forum-rails** was against this. I decided that comments should not be infinitely recursive (That is, you cannot continually create comments of a comment). The easiest way to enforce this constraint is to create a separate model to represent the comment of a comment. Since the `Reply` model does not have any other associations, it will always be the lowest level in the hierachy.

Functionally, they are very similar to comments, except for the fact that they cannot be muted, since you cannot be notified about a reply to a reply anyway because it is not possible to do so, in the context of **mini-forum-rails**.

```ruby
# app/models/reply.rb
class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :content, length: { maximum: 10000 }, presence: true
end
```

```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :replies, dependent: :destroy

  validates :content, length: { maximum: 10000 }, presence: true
end
```

While this does mean a lot of the code between replies and comments will be repeated, it also does mean replies can be treated differently, since their controllers can also contain different codes. While not impossible to do so with a comment polymorphically associated with other comments, it would be much more complex. This is important in the context of notifications, when the content of the notification must be different depending on the subject. The notification will display *replied to* rather than *commented on* to be more informative for the end user.
