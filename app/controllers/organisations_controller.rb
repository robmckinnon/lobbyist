class OrganisationsController < ApplicationController

  caches_action :index, :show

  before_filter :find_organisation, :only => [:show, :edit, :show_staff_member]
  before_filter :store_location, :only => [:index]

  def index
    @organisations = Organisation.find(:all, :order => "name")
    @lobbyists = @organisations.select {|x| x.is_lobbyist_firm? }
    @lobbyist_count = @lobbyists.size

    @others = @organisations - @lobbyists
    @other_count = @others.size

    @organisations_lobbying = @others.select{|x| !x.consultancy_clients.empty? || !x.monitoring_clients.empty?}
    @organisations_lobbying_count = @organisations_lobbying.size

    @quangos = Organisation.quangos
    @quangos_lobbying = (@organisations_lobbying & @quangos)
    @quangos_lobbying_count = @quangos_lobbying.size

    @members_interests = @others.select{|x| !x.members_organisation_interests.empty? }
    @members_interests_count = @members_interests.size
  end

  def new
    @organisation = Organisation.new
  end

  def show_staff_member
    person_id = params[:person_id]
    @consultancy_staff_members, @entries_by_consultancy_staff_member = @organisation.entries_by_consultancy_staff_member2

    @matching_staff_members = @consultancy_staff_members.select{|x| x.friendly_id == person_id }
    @consultancy_staff_member = @matching_staff_members.first
    @register_entries = @matching_staff_members.collect(&:register_entry)

    @consultants = @consultancy_staff_member ? (ConsultancyStaffMember.find_all_by_name(@consultancy_staff_member.name) - @matching_staff_members) : []
    @people = @consultancy_staff_member ? Person.find_all_by_name(@consultancy_staff_member.name) : []
  end

  def show
    @register_entries = @organisation.register_entries

    @consultancy_staff_members, @entries_by_consultancy_staff_member = @organisation.entries_by_consultancy_staff_member

    recent, past = @organisation.consultancy_entries_by_lobbyist_firm
    @consultancy_lobbyist_firms, @consultancy_entries_by_lobbyist_firm = recent
    @past_consultancy_lobbyist_firms, @past_consultancy_entries_by_lobbyist_firm = past

    recent, past = @organisation.monitoring_entries_by_lobbyist_firm
    @monitoring_lobbyist_firms, @monitoring_entries_by_lobbyist_firm = recent
    @past_monitoring_lobbyist_firms, @past_monitoring_entries_by_lobbyist_firm = past

    @consultancy_client_organisations, @consultancy_entries_by_client_organisation = @organisation.consultancy_entries_by_client_organisation
    @monitoring_client_organisations, @monitoring_entries_by_client_organisation = @organisation.monitoring_entries_by_client_organisation

    @members_interests_items = @organisation.members_interests_items
    @appointments = @organisation.appointments

    @similarly_named = @organisation.similarly_named

    @groups = @organisation.organisation_groups
    @company = @organisation.company_number.blank? ? nil : Company.find_by_company_number(@organisation.company_number)
    render :template => 'organisations/show.html.haml'
  end

  def edit
    @similarly_named = @organisation.similarly_named
    @groups = @organisation.organisation_groups
    @next_organisation_with_similarly_named = @organisation.next_organisation_with_similarly_named
    @organisations = Organisation.all_with_matches_at_top(@organisation)
  end

  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      session[:organisation_id] = @organisation.id
      redirect_back_or_default organisations_path
    else
      render :action => :new
    end
  end

  def update
    @organisation = Organisation.find(params[:id])

    merge_with_id = params[:organisation][:merge_with_id]

    if !merge_with_id.blank? && organisation = Organisation.find(merge_with_id)
      @organisation.merge!(organisation)
      flash[:notice] = "Successfully merged #{@organisation.name} into #{link_to_organisation organisation}."
      redirect_to organisation_path(organisation)
    elsif @organisation.update_attributes(params[:organisation])
      flash[:notice] = "Successfully updated #{link_to_organisation @organisation}."
      redirect_to organisations_path
    else
      render :action => 'edit'
    end
  end

  private

    def link_to_organisation organisation
      "<a href='#{organisation_path(organisation)}'>#{organisation.name}</a>"
    end

    def find_organisation
      begin
        @organisation = Organisation.find(params[:id])
        redirect_to @organisation, :status => :moved_permanently if @organisation.has_better_id?
      rescue
        render_not_found
      end
    end

end
