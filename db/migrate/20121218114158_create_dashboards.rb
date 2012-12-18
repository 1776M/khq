class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :name
      t.integer :basecase_id

      t.timestamps
    end
  end
end
