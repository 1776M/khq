class ChangeActannualsDefault < ActiveRecord::Migration
  def up
    change_column_default :actannuals, :name, nil
  end

  def down
  end
end
