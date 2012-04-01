class CreateFxrates < ActiveRecord::Migration
  def change
    create_table :fxrates do |t|
      t.string :currency_pair
      t.float :rate_year_0
      t.float :rate_year_1
      t.float :rate_year_2
      t.float :rate_year_3
      t.float :rate_year_4
      t.float :rate_year_5
      t.float :volatility
      t.float :correlation 

      t.timestamps
    end
  end
end
