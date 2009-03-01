module AppointeesHelper

  def add_former_role_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :former_roles, :partial => 'appointees/former_role' , :object => FormerRole.new
    end
  end

  def add_appointment_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :appointments, :partial => 'appointees/appointment' , :object => Appointment.new
    end
  end
end
