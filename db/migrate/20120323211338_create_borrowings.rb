class CreateBorrowings < ActiveRecord::Migration
  def change
    create_table :borrowings do |t|
      t.float :size
      t.float :coupon
      t.integer :issue_year
      t.integer :maturity_year 
      t.string :fixed_float
      t.integer :basecase_id

      t.timestamps
    end
  end
end
