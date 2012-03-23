class CreateBasecases < ActiveRecord::Migration
  def change
    create_table :basecases do |t|
      t.string :name,       :default => "Core data"
      t.string :group_id

      t.timestamps
    end
  end
end
