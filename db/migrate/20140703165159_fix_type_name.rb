class FixTypeName < ActiveRecord::Migration
  def up
    rename_column :periods, :type, :ptype
  end

  def down
  end
end
