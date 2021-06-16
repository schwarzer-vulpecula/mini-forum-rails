class Notification < ApplicationRecord
  enum event: { 'user_commented_on_post' => 0, 'user_replied_to_comment' => 1 }

  belongs_to :user

  # Creates a notification for object owner that subject has commented on it
  def self.user_commented_on_post(subject, verb, object)
    owner = object.user
    return if subject == owner || object.mute
    notification = owner.notifications.new(event: :user_commented_on_post, subject: subject.id, verb: verb.id, object: object.id)
    notification.save
  end

  # Similar to the above, but for replies
  def self.user_replied_to_comment(subject, verb, object)
    owner = object.user
    return if subject == owner || object.mute
    notification = owner.notifications.new(event: :user_replied_to_comment, subject: subject.id, verb: verb.id, object: object.id)
    notification.save
  end

end
