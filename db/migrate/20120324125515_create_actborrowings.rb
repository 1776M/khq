class CreateActborrowings < ActiveRecord::Migration
  def change
    create_table :actborrowings do |t|
      t.float :size
      t.float :coupon
      t.integer :issue_year
      t.integer :maturity_year 
      t.string :fixed_float
      t.integer :scenario_id

      t.timestamps
    end
  end
end
