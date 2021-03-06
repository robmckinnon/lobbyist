
class CreateSicUkTables < ActiveRecord::Migration

  # SIC(2003) example
  #
  # Section     D         Manufacturing
  # Subsection  DA        Manufacture of Food Products, Beverages and Tobacco
  # Division    15        Manufacture of Food Products and Beverages
  # Group       15.1      Production, processing and preserving of meat and meat products
  # Class       15.11     Production and preserving of meat
  # Subclass    15.11/1   Slaughtering of animals other than poultry and rabbits

  # SIC(2007) example
  #
  # SECTION     C         MANUFACTURING
  # Division    10        Manufacture of food products
  # Group       10.1      Processing and preserving of meat and production of meat products
  # Class       10.11     Processing and preserving of meat
  # Subclass    10.51/1   Liquid milk and cream production

  def self.up
    foreign_keys = {
        :sic_uk_subsections => [:sic_uk_section_id],
        :sic_uk_divisions => [:sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_groups => [:sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_classes => [:sic_uk_group_id, :sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_subclasses => [:sic_uk_class_id, :sic_uk_group_id, :sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id] }

    [:sic_uk_sections, :sic_uk_subsections, :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses].each do |table|
      create_table table do |t|
        t.integer :year
        t.string :code
        t.string :description

        foreign_keys[table].each do |foreign_key|
          t.integer foreign_key
        end unless (table == :sic_uk_sections)

        if (table == :sic_uk_classes) || (table == :sic_uk_subclasses)
          t.integer :sic_uk_code
        end
      end

      foreign_keys[table].each do |foreign_key|
        add_index table, foreign_key
      end unless (table == :sic_uk_sections)
    end

    add_index :sic_uk_classes, :sic_uk_code
    add_index :sic_uk_subclasses, :sic_uk_code
  end

  def self.down
    [:sic_uk_sections, :sic_uk_subsections, :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses].each do |table|
      drop_table table
    end
  end
end
