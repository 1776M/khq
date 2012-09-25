class CreateEpochFxrates < ActiveRecord::Migration
  def change
    create_table :epoch_fxrates do |t|
      t.string :currency_pair
      t.integer :year
      t.float :rate

      t.timestamps
    end
  end
end
