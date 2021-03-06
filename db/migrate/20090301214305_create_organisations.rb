class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.string :alternate_name
      t.string :url
      t.string :wikipedia_url
      t.string :spinwatch_url
      t.string :company_number
      t.string :registered_name

      t.timestamps
    end

    Organisation.create :name => 'Parliament',
        :alternate_name => 'House of Commons',
        :url => 'http://www.parliament.uk/'

    Organisation.create :name => 'Association of Professional Political Consultants',
        :alternate_name => 'APPC',
        :url => 'http://www.appc.org.uk/'

    Organisation.create :name => 'Advisory Committee on Business Appointments',
        :alternate_name => 'ACOBA',
        :url => 'http://www.acoba.gov.uk/'
  end

  def self.down
    drop_table :organisations
  end
end
