class Restaurant < ActiveRecord::Base

	belongs_to :user
  has_many :reviews, dependent: :destroy

	validates :name, length: {minimum: 3}, uniqueness: true

  def has_been_reviewed_by?(user)
      reviews.find_by(user: user)
  end

  def average_rating
    return 'N/A' if reviews.none?
    reviews.average(:rating)
  end

end
