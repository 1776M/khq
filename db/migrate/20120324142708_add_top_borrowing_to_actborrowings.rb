class AddTopBorrowingToActborrowings < ActiveRecord::Migration
  def change
    add_column :actborrowings, :top_borrowing, :integer
  end
end
