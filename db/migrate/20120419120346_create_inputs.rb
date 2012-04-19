class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :name
      t.string :body

      t.integer :basecase_id

      t.timestamps
    end
  end
end
