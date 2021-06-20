---

layout: default

---

## Table of Contents
- [Basic Information](./)
- [Static Pages](./static-pages)
- [Users](./users)
- [Sessions](./sessions)
- [Posts](./posts)
- [Comments and Replies](./comments-replies)
- [Notifications](./notifications)
- [Common Features](./common-features)
- [Other Projects](https://schwarzer-vulpecula.github.io)

# Basic Information

This repository contains code of a forum where users can create posts. This is written on Ruby using the Rails framework.

Several key features include:

* Comments and replies
* Notifications and the ability to mute them
* User authentication with password hashing
* User moderation and user ranks
* Website redirections that make sense
* Input sanitation and proper formatting
* Basic searching for users, posts, and user specific posts

Several things that should be noted:

* By default, nobody can destroy a user for security reasons
* User creation has no verification (ie. emails), as that is outside the scope of this project
* There is no forget password feature because of this
* User ranks must be set by editing the entry in the database, you can use the rails console for this
* This is not production ready and is not meant to be used as is.

Version Information:

* Ruby: `3.0.1`
* Rails: `6.1.3.2`
* Other than that, I believe nothing else should be needed

How to run:
* Go into the directory
* Run `rails db:setup` in the terminal
* Run `rails server`
* If you're getting a Webpacker::Manifest::MissingEntryError, run `rails webpacker:install`
* Everything should be working afterwards

