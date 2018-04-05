class CreateLeavePeroids < ActiveRecord::Migration[5.0]
  def change
    create_table :leave_peroids do |t|
      t.references :user
      t.datetime :start_time
      t.datetime :end_time
      t.float :assigned
      t.float :used, default: 0, null: false
      t.timestamps
    end
    add_index :leave_peroids, [:user_id,:start_time,:end_time], unique: true
  end
end
