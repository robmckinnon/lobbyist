class CreateFormerRoles < ActiveRecord::Migration
  def self.up
    create_table :former_roles do |t|
      t.integer :appointee_id
      t.integer :department_id
      t.string :title
      t.string :department_name
      t.date :leaving_service_date

      t.timestamps
    end
  end

  def self.down
    drop_table :former_roles
  end
end
