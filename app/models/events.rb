class Events < ActiveRecord::Base
  def change
    create_table :events do |t|
      t.event_name :string
      t.event_data :datetime
      t.user :string
      t.period :integer

      t.timestamps
    end
  end
end