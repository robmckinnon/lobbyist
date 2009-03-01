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

    add_index :former_roles, :appointee_id
    add_index :former_roles, :department_id
  end

  def self.down
    drop_table :former_roles
  end
end
