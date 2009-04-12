class AppcRegisterEntry

  attr_reader :register_entry
  attr_accessor :data_source_id

  class << self
    def create_register_entry data_source_id, data
      entry = AppcRegisterEntry.new
      entry.data_source_id = data_source_id
      entry.data = data
      register_entry = entry.register_entry
      register_entry.save!
      entry
    end
  end

  def data= data
    entry = RegisterEntry.new
    entry.data_source_id = @data_source_id.to_i
    state = nil
    data.gsub!("\r\n","\n")
    data.each_line do |line|
      text = RegisterEntry.clean_text(line)
      if RegisterEntry.valid_name?(text)
        state = handle(entry, line, text, state)
      end
    end

    entry.office_contacts.first.details.strip! if entry.office_contacts.first
    entry.offices_outside_the_uk.strip! if entry.offices_outside_the_uk

    entry.consultancy_clients.each do |client|
      RegisterEntry.clean_names(client)
    end
    entry.monitoring_clients.each do |client|
      RegisterEntry.clean_names(client)
    end

    @register_entry = entry
  end

  private
    def handle(entry, line, text, state)
      if entry.organisation_name?
        handle_by_text(entry, line, text, state)
      else
        entry.organisation_name = text
        return state
      end
    end

    def handle_by_text(entry, line, text, state)
      case text
        when /^(APPC Register Entry|Contact)/ # ignore
          state
        when /^Address\(es\) in UK/
          entry.office_contacts.build
          entry.office_contacts.first.details = ''
          :office_contact
        when /^Website:(.+)$/
          entry.organisation_url = $1.strip
          nil
        when /^Offices outside UK/
          entry.offices_outside_the_uk = ''
          :offices_outside_the_uk
        when /^Staff \(employed and sub-contracted\) providing PA consultancy services/i
          :consultancy_staff
        when /^Fee-Paying clients for whom UK PA consultancy services/i
          :consultancy_clients
        when /^Fee-Paying Clients for whom only UK monitoring services/i
          :monitoring_clients
        when /^Pro-Bono Clients for whom consultancy/i
          :pro_bono_clients
        else
          handle_by_state(entry, line, text, state)
          state
      end
    end

    def handle_by_state(entry, line, text, state)
      case state
        when :office_contact
          entry.office_contacts.first.details = entry.office_contacts.first.details + "\n" + text
        when :offices_outside_the_uk
          entry.offices_outside_the_uk = entry.offices_outside_the_uk + "\n" + text
        when :consultancy_staff
          entry.consultancy_staff_members << ConsultancyStaffMember.new(:name => text)
        when :consultancy_clients
          add_client(entry, line, text, ConsultancyClient, :consultancy_clients)
        when :monitoring_clients
          add_client(entry, line, text, MonitoringClient, :monitoring_clients)
        when :pro_bono_clients
          # ignore for now
      end
    end

    def add_client(entry, line, text, model, method)
      if line.strip[/^•/] || line.starts_with?("􀂃")
        entry.send(method) << model.new(:name => text)
      else
        begin
          entry.send(method).last.name = entry.send(method).last.name + ' ' + text
        rescue
          raise method.to_s + ': ' + text
        end
      end
    end
end
