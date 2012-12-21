class CreateArbs < ActiveRecord::Migration
  def change
    create_table :arbs do |t|
      t.text :name
      t.integer :basecase_id

      t.timestamps
    end
  end
end
