class CreateLeaveEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :leave_events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :hours
      t.text :reason
      t.references :user
      t.integer :status, default: 0
      t.text :description
      t.integer :approver_id

      t.timestamps
    end
    add_index :leave_events, [:start_time,:end_time], unique: true
  end
end
