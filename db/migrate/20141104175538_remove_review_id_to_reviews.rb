class RemoveReviewIdToReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :review_id
  end
end
