class CreateGains < ActiveRecord::Migration
  def change
    create_table :gains do |t|
      t.string :name
      t.float :year_0
      t.float :year_1
      t.float :year_2
      t.float :year_3
      t.float :year_4
      t.float :year_5
      t.integer :scenario_id

      t.timestamps
    end
  end
end
