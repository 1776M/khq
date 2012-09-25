class CreateEpochdates < ActiveRecord::Migration
  def change
    create_table :epochdates do |t|
      t.string :currency
      t.integer :start_year
      t.integer :scenario_id

      t.timestamps
    end
  end
end
