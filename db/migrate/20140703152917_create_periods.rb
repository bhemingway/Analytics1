class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string  :name
      t.integer :ptype
      t.date    :lodate
      t.date    :hidate
      t.date    :voter_reg_lodate
      t.date    :voter_reg_hidate

      t.timestamps
    end
  end
end
