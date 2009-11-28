class OrganisationGroupsController < ApplicationController

  before_filter :find_organisation_group, :only => [:show, :edit]

  before_filter :set_organisations, :only => [:new, :edit]
  before_filter :set_sic_uk_classes, :only => [:new, :edit]

  def index
    @groups = OrganisationGroup.all
  end

  def show
    @organisations = @group.organisations
    @members_interests_items = @group.members_interests_items
    @appointments = @group.appointments

    @consultancy_client_organisations = []
    @consultancy_entries_by_client_organisation = {}
    @monitoring_client_organisations = []
    @monitoring_entries_by_client_organisation = {}

    @consultancy_lobbyist_firms, @consultancy_entries_by_lobbyist_firm = [], {}
    @past_consultancy_lobbyist_firms, @past_consultancy_entries_by_lobbyist_firm = [], {}
    @monitoring_lobbyist_firms, @monitoring_entries_by_lobbyist_firm = [], {}
    @past_monitoring_lobbyist_firms, @past_monitoring_entries_by_lobbyist_firm = [], {}

    @organisations.each do |organisation|
      clients, entries_hash = organisation.consultancy_entries_by_client_organisation
      @consultancy_client_organisations += clients
      @consultancy_entries_by_client_organisation = entries_hash.merge(@consultancy_entries_by_client_organisation)

      clients, entries_hash = organisation.monitoring_entries_by_client_organisation
      @monitoring_client_organisations += clients
      @monitoring_entries_by_client_organisation = entries_hash.merge(@monitoring_entries_by_client_organisation)

      recent, past = organisation.consultancy_entries_by_lobbyist_firm
      @consultancy_lobbyist_firms += recent[0]
      @consultancy_entries_by_lobbyist_firm = recent[1].merge(@consultancy_entries_by_lobbyist_firm)
      @past_consultancy_lobbyist_firms += past[0]
      @past_consultancy_entries_by_lobbyist_firm = past[1].merge(@past_consultancy_entries_by_lobbyist_firm)

      recent, past = organisation.monitoring_entries_by_lobbyist_firm
      @monitoring_lobbyist_firms += recent[0]
      @monitoring_entries_by_lobbyist_firm = recent[1].merge(@monitoring_entries_by_lobbyist_firm)
      @past_monitoring_lobbyist_firms += past[0]
      @past_monitoring_entries_by_lobbyist_firm = past[1].merge(@past_monitoring_entries_by_lobbyist_firm)
    end
    @consultancy_lobbyist_firms.uniq!
    @monitoring_lobbyist_firms.uniq!
    @past_consultancy_lobbyist_firms.uniq!
    @past_monitoring_lobbyist_firms.uniq!
  end

  def new
    @group = OrganisationGroup.new
    # @group.organisation_group_members.build
    @group.organisation_group_members = []
  end

  def edit
  end

  def create
    @group = OrganisationGroup.new(params[:organisation_group])
    if @group.save
      flash[:notice] = "Successfully created <a href='organisation_groups/#{@group.friendly_id}'>#{@group.name}</a> group."
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
