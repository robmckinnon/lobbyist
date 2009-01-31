class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.integer :appointee_id
      t.string :title
      t.string :organisation_name
      t.integer :organisation_id
      t.text :acoba_advice
      t.date :date_tendered
      t.date :date_taken_up
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end
