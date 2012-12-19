class CreateSenses < ActiveRecord::Migration
  def change
    create_table :senses do |t|
      t.string :name
      t.integer :face_id

      t.timestamps
    end
  end
end
