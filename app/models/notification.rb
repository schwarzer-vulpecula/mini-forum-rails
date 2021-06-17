class Notification < ApplicationRecord
  enum event: { 'user_commented_on_post' => 0, 'user_replied_to_comment' => 1, 'staff_posted_announcement' => 2 }

  belongs_to :user

  # Creates a notification for object owner that subject has commented on it
  def self.user_commented_on_post(subject, verb, object)
    owner = object.user
    return if subject == owner || object.mute
    owner.notifications.create(event: :user_commented_on_post, subject: subject.id, verb: verb.id, object: object.id)
  end

  # Similar to the above, but for replies
  def self.user_replied_to_comment(subject, verb, object)
    owner = object.user
    return if subject == owner || object.mute
    owner.notifications.create(event: :user_replied_to_comment, subject: subject.id, verb: verb.id, object: object.id)
  end

  def self.staff_posted_announcement(subject, object)
    User.all.each do |user|
      next if user == subject
      user.notifications.create(event: :staff_posted_announcement, subject: subject.id, object: object.id)
    end
  end

end
