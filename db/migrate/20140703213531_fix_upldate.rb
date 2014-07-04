class FixUpldate < ActiveRecord::Migration
  def up
    change_column :logs, :upldate, :string
    rename_column :logs, :upldate, :filename
  end

  def down
  end
end
