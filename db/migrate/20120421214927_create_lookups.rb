class CreateLookups < ActiveRecord::Migration
  def change
    create_table :lookups do |t|
      t.text :name
      t.integer  "basecase_id"

      t.timestamps
    end
  end
end
