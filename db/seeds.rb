# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

time = Time.now - 5.years
User.create(username: 'nine-tails', password: 'password1', display_name: 'Vulpes', avatar: 'silver', about_me: 'Do you believe my posts?', rank: 'administrator', created_at: time, updated_at: time)
Post.create(title: 'This is a 5 year old post', content: 'In the beginning, I was lonely.', user_id: 1, created_at: time, updated_at: time, recent_activity: time)

time = time + 9.months
User.create(username: 'monochrome-clock', password: 'password2', display_name: 'Velox', avatar: 'velox', about_me: 'There are things out there worth exploring.', created_at: time, updated_at: time)
Post.create(title: 'This post is 4 years and 3 months old', content: 'I\'m just stopping by to say hello.', user_id: 2, created_at: time, updated_at: time, recent_activity: time + 5.minutes)
Comment.create(content: 'Hello! Enjoy your stay!', user_id: 1, post_id: 2, created_at: time + 5.minutes, updated_at: time + 5.minutes)
Notification.create(user_id: 2, event: :user_commented_on_post, subject: 1, verb: 1, object: 2, created_at: time + 5.minutes, updated_at: time + 5.minutes, read: true)

time = time + 3.months + 3.years
User.create(username: 'honest-rumors', password: 'password3', display_name: 'Stenognathus', avatar: 'stenognathus', about_me: 'Silence is golden, but knowledge is platinum.', created_at: time, updated_at: time)
Post.create(title: '1 year old post but comments are minutes older.', content: "I heard this place is a good source of truthful news.\nBtw, I edited this post 2 months later.", user_id: 3, created_at: time, updated_at: time + 2.months, recent_activity: time + 10.minutes)
Comment.create(content: 'Welcome! I\'m not sure where you got that from, but there is only me and one inactive user here.', user_id: 1, post_id: 3, created_at: time + 5.minutes, updated_at: time + 5.minutes)
Reply.create(content: "What? That can't be right. There's no way my source is wrong!\nBtw, I edited this reply 3 months later.", user_id: 3, comment_id: 2, created_at: time + 10.minutes, updated_at: time + 10.minutes + 3.months)

time = time + 1.months
User.create(username: 'black-and-white', password: 'password4', display_name: 'Lagopus', avatar: 'lagopus', about_me: 'Who are you calling hot and cold!?', rank: 'moderator', created_at: time, updated_at: Time.now - 14.days)
Post.create(title: 'This post is 11 months old', content: 'Anyone know how to get rid of a megacorporation posing as the government?', user_id: 4, created_at: time, updated_at: time, recent_activity: time + 30.minutes)
Comment.create(content: 'Right now, I\'m doing everything I can while undercover.', user_id: 4, post_id: 4, created_at: time, updated_at: time)
time = time + 5.minutes
Comment.create(content: 'Where are you from? This sounds like big news to me!', user_id: 3, post_id: 4, created_at: time, updated_at: time)
Reply.create(content: 'I\'m curious, how do you keep yourself hidden?', user_id: 1, comment_id: 3, created_at: time, updated_at: time)
time = time + 5.minutes
Comment.create(content: 'By using your charm and wits, and some clever persuasion.', user_id: 1, post_id: 4, created_at: time, updated_at: time)
time = time + 15.minutes
Reply.create(content: 'Glasses, obviously', user_id: 4, comment_id: 3, created_at: time, updated_at: time)
Reply.create(content: 'Where else? Isn\'t it obvious?', user_id: 4, comment_id: 4, created_at: time, updated_at: time)
time = time + 5.minutes
Reply.create(content: 'Nevermind. Carry on, then.', user_id: 3, comment_id: 4, created_at: time, updated_at: time)

time = Time.now - 6.months
User.create(username: 'fOrTiTuDe', password: 'password5', display_name: 'Ferrilata', avatar: 'ferrilata', about_me: 'Try to stop me.', created_at: time, updated_at: time)
Post.create(title: '<b>This post is 6 months old and contains HTML</b>', content: "<h1><b>I am creating a new guild for 'that' game</b></h1>\n<h2><b>I seek worthy opponents</b></h2>\n<h3><b>Guild ID: 111 222 333</b></h3>\n<h4><b>Put your ID below so I know who to accept.</b></h4>\nEDIT: Why is the code not working?", user_id: 5, created_at: time, updated_at: time + 5.minutes, recent_activity: time + 20.minutes)
Comment.create(content: "Sent!\nID: 345 678 912", user_id: 3, post_id: 5, created_at: time, updated_at: time)
Reply.create(content: 'Very quick. I like that.', user_id: 5, comment_id: 6, created_at: time, updated_at: time)
time = time + 15.minutes
Comment.create(content: "Sent!\nID: 123 456 789\nGood luck, I\'m good at playing tricks~\nAlso, your code isn't working because it's in plain text.", user_id: 1, post_id: 5, created_at: time, updated_at: time)
Reply.create(content: "Finally, a worthy opponent.\nThough I'm not sure what you mean by plain text.", user_id: 5, comment_id: 7, created_at: time, updated_at: time)
Reply.create(content: "I'll tell you in game, somehow.", user_id: 1, comment_id: 7, created_at: time + 5.minutes, updated_at: time + 5.minutes)

time = Time.now - 2.months
User.create(username: 'princess-diva', password: 'password6', display_name: 'Zerda', avatar: 'zerda', created_at: time, updated_at: time)
Post.create(title: "This 2 month old post contains emojis 🎵", content: "🎵", user_id: 6, created_at: time, updated_at: time, recent_activity: Time.now - 6.hours + 1.minutes)
Comment.create(content: "🍃", user_id: 3, post_id: 6, created_at: time, updated_at: time)
Reply.create(content: "😨", user_id: 6, comment_id: 8, created_at: time, updated_at: time)
Comment.create(content: "🤺", user_id: 4, post_id: 6, created_at: time + 1.minutes, updated_at: time + 1.minutes)
Comment.create(content: "🦊", user_id: 1, post_id: 6, created_at: time + 2.minutes, updated_at: time + 2.minutes)
Comment.create(content: "🐲", user_id: 5, post_id: 6, created_at: time + 3.minutes, updated_at: time + 3.minutes)

time = Time.now - 45.days
User.create(username: 'time-watcher', password: 'password7', display_name: 'Macrotis', avatar: 'macrotis', about_me: "45 days is all I have.", rank: 'moderator', created_at: time, updated_at: Time.now - 14.days)
time = time + 9.days
Post.create(title: "This post is 38 days old", content: "Why do you destroy your notifications?", user_id: 7, created_at: time, updated_at: time, recent_activity: time + 12.hours + 5.minutes)
Comment.create(content: "I like keeping mine empty. I don't want old news.", user_id: 3, post_id: 7, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 3, verb: 12, object: 7, created_at: time, updated_at: time, read: true)
Comment.create(content: "I always remove one as soon as I finish reading it.\nIt's much more organized that way.", user_id: 4, post_id: 7, created_at: time + 1.hours, updated_at: time + 1.hours)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 4, verb: 13, object: 7, created_at: time + 1.hours, updated_at: time + 1.hours, read: true)
Comment.create(content: "Do you not enjoy destroying things that are no longer useful?", user_id: 5, post_id: 7, created_at: time + 12.hours, updated_at: time + 12.hours)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 5, verb: 14, object: 7, created_at: time + 12.hours, updated_at: time + 12.hours, read: true)
Reply.create(content: "This comment was posted 12 hours later.\nThis is bad.", user_id: 7, comment_id: 14, created_at: time + 12.hours, updated_at: time + 12.hours)
Reply.create(content: "?", user_id: 5, comment_id: 14, created_at: time + 12.hours + 5.minutes, updated_at: time + 12.hours + 5.minutes)

time = Time.now - 14.days
Post.create(title: "This is an announcement from 14 days ago", content: "Users Lagopus (@black-and-white) and Macrotis (@time-watcher) are now Moderators!", user_id: 1, created_at: time, updated_at: time, recent_activity: Time.now - 6.hours + 45.minutes)
Notification.create(user_id: 2, event: :staff_posted_announcement, subject: 1, object: 8, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :staff_posted_announcement, subject: 1, object: 8, created_at: time, updated_at: time, read: true)
Comment.create(content: "Congrats!\nBtw, I edited this comment yesterday.", user_id: 3, post_id: 8, created_at: time, updated_at: Time.now - 1.days)
Comment.create(content: "👏", user_id: 6, post_id: 8, created_at: time + 5.minutes, updated_at: time + 5.minutes)
Comment.create(content: "Congratulations. This is the first step towards greatness.", user_id: 5, post_id: 8, created_at: time + 15.minutes, updated_at: time + 15.minutes)
time = time + 30.minutes
Reply.create(content: "Thank you!", user_id: 4, comment_id: 15, created_at: time, updated_at: time)
Reply.create(content: "🤗", user_id: 4, comment_id: 16, created_at: time, updated_at: time)
Reply.create(content: "Thank you!", user_id: 4, comment_id: 17, created_at: time, updated_at: time)

time = Time.now - 12.days
User.create(username: 'tactical-k9', password: 'password8', display_name: 'Corsac', avatar: 'corsac', about_me: "Don't mind me, I'm just grabbing some popcorn.", created_at: time, updated_at: time)
Post.create(title: "Привет! 12 days old post with foreign characters", content: "Здравствуйте, I finally decided to join this forum.\nI've been lurking around and reading what interesting things people have posted for over a year now.\nAlso, don't bother commenting, I've muted this post.", user_id: 8, created_at: time, updated_at: time, recent_activity: Time.now - 6.hours + 5.minutes, mute: true)
Comment.create(content: "❄️", user_id: 8, post_id: 6, created_at: time, updated_at: time)
time = time + 3.hours
Comment.create(content: "こんにちは！", user_id: 3, post_id: 9, created_at: time, updated_at: time)
time = time + 5.minutes
Comment.create(content: "안녕하세요!", user_id: 1, post_id: 9, created_at: time, updated_at: time)
time = time + 55.minutes
Comment.create(content: "You guys are having wayyy too much fun -_-", user_id: 4, post_id: 9, created_at: time, updated_at: time)

time = Time.now - 3.days
Post.create(title: "Long 3 days old post of a poorly translated lyrics", content: "
Oh, the road to a distant country\n
White light illuminates the darkness\n
Please tell me where you are\n
Push the button forward to move it.\n
(Oh, I cried a lot at night)\n
Farewell to the past\n
(Because I was there)\n
The tomatoes don't come back.\n
Execution lasts forever\n
Great love and wisdom\n
heart\n
Get stronger and go to the moon\n
death\n
I took this opportunity\n
We will be bright\n
Go anywhere\n
Light is eternal\n
So I know my concerns.\n
Under the stars\n
Why does it hurt so much?\n
Look, wait a minute.\n
(Oh, I cried a lot at night)\n
never look back\n
(Because I was there)\n
I'm not afraid to move on\n
Let's wash it.\n
love\n
Heartbeat\n
Without thinking, we run in a city of peace.\n
Health needs\n
Don't miss the time\n
We will be bright\n
Go anywhere\n
Light is eternal\n
Let's dance!\n
straight away\n
Let's go to heaven\n
Believe in everything and look to the future\n
I love you with all my heart\n
heart\n
Get stronger, look forward to it, and move forward.\n
today as well\n
I lost my happiness, my dreams\n
This is the story you believe in and is clearly written.\n
Go anywhere\n
Light is eternal\n
Go anywhere\n
Light is eternal\n
", user_id: 6, created_at: time, updated_at: time, recent_activity: time)

time = Time.now - 12.hours
User.create(username: 'aqua-regia', password: 'password9', display_name: 'Vulpes', avatar: 'vulpes-schrencki', about_me: "Humans have made us suffer for far too long.", banned: true, ban_message: "You tried to nuke the forum.", created_at: time, updated_at: time + 6.hours + 20.minutes)
Post.create(title: "Post from 12 hours ago, with lots of comments", content: "In 2 hours time, I will be nuking this forum, starting from the comments section, unless someone comments \"Justice for the foxes!\".", user_id: 9, created_at: time, updated_at: time, recent_activity: time + 2.hours + 20.minutes)
time = time + 2.hours
Comment.create(content: "Your silence is answer enough.", user_id: 9, post_id: 11, created_at: time, updated_at: time)
for i in 1..20 do
  Comment.create(content: "Spam comment #{i}", user_id: 9, post_id: 11, created_at: time + i.minutes, updated_at: time + i.minutes)
end

time = Time.now - 6.hours
Post.create(title: "I have returned! Just 6 hours ago.", content: "A lot has happened, huh.", user_id: 2, created_at: time, updated_at: time, recent_activity: Time.now - 3.hours)
Comment.create(content: "🕒", user_id: 2, post_id: 6, created_at: time + 1.minutes, updated_at: time + 1.minutes)
Comment.create(content: "Congratulations.", user_id: 2, post_id: 8, created_at: time + 2.minutes, updated_at: time + 2.minutes)
Comment.create(content: "שלום", user_id: 2, post_id: 9, created_at: time + 5.minutes, updated_at: time + 5.minutes)
time = time + 30.minutes
Comment.create(content: "You're late.", user_id: 7, post_id: 12, created_at: time, updated_at: time)
Notification.create(user_id: 2, event: :user_commented_on_post, subject: 7, verb: 46, object: 12, created_at: time, updated_at: time)
time = time + 15.minutes
Reply.create(content: "Better late than never, I suppose.\nThank you.", user_id: 4, comment_id: 44, created_at: time, updated_at: time)
Notification.create(user_id: 2, event: :user_replied_to_comment, subject: 4, verb: 15, object: 44, created_at: time, updated_at: time)
time = Time.now - 3.hours
Comment.create(content: "Where have you been? I missed you.", user_id: 1, post_id: 12, created_at: time, updated_at: time)
Notification.create(user_id: 2, event: :user_commented_on_post, subject: 1, verb: 47, object: 12, created_at: time, updated_at: time)

time = Time.now - 15.minutes
Post.create(title: "This is a very recent announcement.", content: "The end is here. I was too late.", user_id: 7, created_at: time, updated_at: time, recent_activity: Time.now - 1.minutes)
User.all.each do |user|
  next if user == User.find(7)
  user.notifications.create(event: :staff_posted_announcement, subject: 7, object: 13, created_at: time, updated_at: time)
end
time = time + 1.minutes
Comment.create(content: "Ooooh, this looks super important!", user_id: 3, post_id: 13, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 3, verb: 48, object: 13, created_at: time, updated_at: time)
time = time + 2.minutes
Comment.create(content: "What's going on? A fight?", user_id: 5, post_id: 13, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 5, verb: 49, object: 13, created_at: time, updated_at: time)
time = time + 1.minutes
Comment.create(content: "❓", user_id: 6, post_id: 13, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 6, verb: 50, object: 13, created_at: time, updated_at: time)
time = time + 2.minutes
Comment.create(content: "This is going to be interesting.", user_id: 8, post_id: 13, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 8, verb: 51, object: 13, created_at: time, updated_at: time)
time = Time.now - 1.minutes
Comment.create(content: "Goodbye, everyone. It's been fun writing all of this.", user_id: 1, post_id: 13, created_at: time, updated_at: time)
Notification.create(user_id: 7, event: :user_commented_on_post, subject: 1, verb: 52, object: 13, created_at: time, updated_at: time)

