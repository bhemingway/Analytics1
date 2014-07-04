class FixReport < ActiveRecord::Migration
  def up
    change_column :reports, :report, :integer
  end

  def down
  end
end
