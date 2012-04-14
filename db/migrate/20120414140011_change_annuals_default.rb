class ChangeAnnualsDefault < ActiveRecord::Migration
  def up
    change_column_default :annuals, :name, nil
  end

  def down
  end
end
