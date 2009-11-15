class OrganisationGroupsController < ApplicationController

  before_filter :find_organisation_group, :only => [:show, :edit]

  before_filter :set_organisations, :only => [:new, :edit]
  before_filter :set_sic_uk_classes, :only => [:new, :edit]

  def show
    @organisations = @group.organisations
  end

  def new
    @group = OrganisationGroup.new
    @group.organisation_group_members.build
  end

  def edit
  end

  def create
    @group = OrganisationGroup.new(params[:organisation_group])
    if @group.save
      flash[:notice] = "Successfully created #{@group.name} group."
      redirect_back_or_default admin_url
    else
      set_sic_uk_classes @group.sic_uk_class_id
      render :action => 'new'
    end
  end

  def update
    @group = OrganisationGroup.find(params[:id])
    # raise params[:organisation_group][:new_organisation_group_member_attributes].inspect

    attributes = params[:organisation_group]
    attributes[:existing_organisation_group_member_attributes] ||= {}

    # raise attributes.inspect
    if @group.update_attributes(attributes)
      flash[:notice] = "Successfully updated entry for #{@group.name}."
      redirect_to :action => 'edit'
    else
      set_sic_uk_classes @group.sic_uk_class_id
      render :action => 'edit'
    end
  end

  private

    def link_to_organisation_group group
      "<a href='#{organisation_group_path(group)}'>#{group.name}</a>"
    end

    def find_organisation_group
      begin
        @group = OrganisationGroup.find(params[:id])
        redirect_to @group, :status => :moved_permanently if @group.has_better_id?
      rescue
        render_not_found
      end
    end

end
