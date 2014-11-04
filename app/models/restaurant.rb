class Restaurant < ActiveRecord::Base

	has_many :reviews, dependent: :destroy

	validates :name, length: {minimum: 3}, uniqueness: true

  def has_been_reviewed_by?(user)
      reviews.find_by(user: user)
  end


end
