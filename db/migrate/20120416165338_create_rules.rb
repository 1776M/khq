class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.integer :basecase_id

      t.timestamps
    end
  end
end
