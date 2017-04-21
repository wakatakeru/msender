class Document < ApplicationRecord
  belongs_to :tag
  validates :title, :presence => true
end
