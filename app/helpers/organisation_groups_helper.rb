module OrganisationGroupsHelper
  def add_organisation_group_member(form_builder, name)
    link_to_function name do |page|
      form_builder.fields_for "new_organisation_group_member_attributes[]", OrganisationGroupMember.new, :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'organisation_groups/new_organisation_group_member', :locals => { :form => f })
        page << "$('group_members').insert({ bottom: '#{escape_javascript(html)}'.replace(/__/g, '_' + (new Date().getTime()) + '_' ).replace('][organisation_id]', '][' + (new Date().getTime()) + '][organisation_id]') });"
      end
    end
  end
end
