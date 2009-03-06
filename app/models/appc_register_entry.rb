class AppcRegisterEntry

  attr_reader :register_entry
  attr_accessor :data_source_id

  def data= data
    entry = RegisterEntry.new
    entry.data_source_id = @data_source_id.to_i
    state = nil

    data.each_line do |line|
      text = RegisterEntry.clean_name(line)
      if RegisterEntry.valid_name?(text)
        if !entry.organisation_name?
          entry.organisation_name = text
        else
          case text
            when /^APPC Register Entry/
              # ignore
            when /^Address\(es\) in UK/
              state = :office_contact
              entry.office_contacts.build
              entry.office_contacts.first.details = ''
            when /^Contact$/
              # ignore
            when /^Website:(.+)$/
              state = nil
              entry.organisation_url = $1.strip
            when /^Offices outside UK/
              state = :offices_outside_the_uk
              entry.offices_outside_the_uk = ''
            when /^Staff \(employed and sub-contracted\) providing PA consultancy services/
              state = :consultancy_staff
            when /^Fee-Paying clients for whom UK PA consultancy services/
              state = :consultancy_clients
            when /^Fee-Paying Clients for whom only UK monitoring services/
              state = :monitoring_clients
            else
              case state
                when :office_contact
                  entry.office_contacts.first.details = entry.office_contacts.first.details + "\n" + text
                when :offices_outside_the_uk
                  entry.offices_outside_the_uk = entry.offices_outside_the_uk + "\n" + text
                when :consultancy_staff
                  staff = ConsultancyStaffMember.new :name => text
                  entry.consultancy_staff_members << staff
                when :consultancy_clients
                  if line.strip[/^•/] || line.starts_with?("􀂃")
                    client = ConsultancyClient.new :name => text
                    entry.consultancy_clients << client
                  else
                    entry.consultancy_clients.last.name = entry.consultancy_clients.last.name + ' ' + text
                  end
                when :monitoring_clients
                  if line.strip[/^•/] || line.starts_with?("􀂃")
                    client = MonitoringClient.new :name => text
                    entry.monitoring_clients << client
                  else
                    begin
                      entry.monitoring_clients.last.name = entry.monitoring_clients.last.name + ' ' + text
                    rescue
                      raise state.to_s + ': ' + text
                    end
                  end
                end
          end
        end
      end
    end

    entry.office_contacts.first.details.strip! if entry.office_contacts.first
    entry.offices_outside_the_uk.strip! if entry.offices_outside_the_uk

    entry.consultancy_clients.each do |c|
      c.name = c.name.squeeze(' ')
      a,b = RegisterEntry.get_names c.name
      unless b.blank?
        c.name = a
        c.name_in_parentheses = b
      end
    end
    entry.monitoring_clients.each do |c|
      c.name = c.name.squeeze(' ')
      a,b = RegisterEntry.get_names c.name
      unless b.blank?
        c.name = a
        c.name_in_parentheses = b
      end
    end

    @register_entry = entry
  end

end
