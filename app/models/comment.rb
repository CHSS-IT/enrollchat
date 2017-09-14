class Comment < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :section, required: true
  has_ancestry cache_depth: true
end
