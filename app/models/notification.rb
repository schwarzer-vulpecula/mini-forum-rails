class Notification < ApplicationRecord
  enum event: { 'user_commented_on_post' => 0, 'user_replied_to_comment' => 1 }
end
