module RegisterEntriesHelper

  def add_office_contact_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :office_contacts, :partial => 'register_entries/office_contact' , :object => OfficeContact.new
    end
  end

  def add_consultancy_staff_member_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :consultancy_staff_members, :partial => 'register_entries/consultancy_staff_member' , :object => ConsultancyStaffMember.new
    end
  end

  def add_consultancy_client_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :consultancy_clients, :partial => 'register_entries/consultancy_client' , :object => ConsultancyClient.new
    end
  end

  def add_monitoring_client_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :monitoring_clients, :partial => 'register_entries/monitoring_client' , :object => MonitoringClient.new
    end
  end
end
