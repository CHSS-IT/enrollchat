class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true
end
