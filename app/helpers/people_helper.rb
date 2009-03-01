module PeopleHelper

  def add_appointee_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :appointees, :partial => 'appointee' , :object => Appointee.new
    end
  end
end
