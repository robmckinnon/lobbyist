class CreateAppointees < ActiveRecord::Migration
  def self.up
    create_table :appointees do |t|
      t.integer :person_id
      t.string :name

      t.timestamps
    end

    add_index :appointees, :person_id
  end

  def self.down
    drop_table :appointees
  end
end
