class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_name
      t.datetime :event_data
      t.string :user
      t.integer :period

      t.timestamps
    end
  end
end
