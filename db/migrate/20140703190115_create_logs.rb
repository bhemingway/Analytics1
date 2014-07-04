class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :comment
      t.date :upldate
      t.string :status
      t.integer :inrecs
      t.integer :outrecs
      t.integer :duperecs

      t.timestamps
    end
  end
end
