class RegisterOfMembersInterestsReport

  attr_reader :data, :register_entries
  attr_accessor :data_source_id

  require 'yaml'

  def data= data
    lines = []
    data.each_line do |line|
      line.strip!
      lines << line unless line.blank?
    end

    entry_data = []
    lines.each_with_index do |text, index|
      case text
        when /^APPC Register Entry/
          entry_data << []
          entry_data.last << lines[index-1]
        else
          if index != 0
            entry_data.last << lines[index-1]
          end
      end
    end
    entry_data.last << lines.last

    @register_entries = entry_data.collect do |lines|
      entry = RegisterOfMembersInterestsEntry.new
      entry.data_source_id = @data_source_id
      entry.data = lines.join("\n")
      entry.register_entry
    end
  end

end
