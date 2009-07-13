class OrganisationsController < ApplicationController

  before_filter :find_organisation, :only => [:show, :edit]
  before_filter :store_location, :only => [:index]

  def index
    @organisations = Organisation.find(:all, :order => "name")
    @lobbyists = @organisations.select {|x| x.is_lobbyist_firm? }
    @lobbyist_count = @lobbyists.size
    @others = @organisations - @lobbyists
    @other_count = @others.size
  end

  def new
    @organisation = Organisation.new
  end

  def show
    @register_entries = @organisation.register_entries
    @consultancy_clients = @organisation.consultancy_clients
    @monitoring_clients = @organisation.monitoring_clients
    @consultancy_clients_by_source = @consultancy_clients.group_by{|x| x.register_entry.data_source}
    @monitoring_clients_by_source = @monitoring_clients.group_by{|x| x.register_entry.data_source}
    @client_data_sources = @consultancy_clients_by_source.keys | @monitoring_clients_by_source.keys # union

    @consultancy_entries_by_lobbyist_firm = @consultancy_clients.collect(&:register_entry).group_by(&:organisation)
    @consultancy_entries_by_lobbyist_firm.each {|k,v| @consultancy_entries_by_lobbyist_firm[k] = v.sort_by{|x| x.data_source.period_start} }
    @consultancy_lobbyist_firm_keys = @consultancy_entries_by_lobbyist_firm.keys.sort_by(&:name)

    @monitoring_entries_by_lobbyist_firm = @monitoring_clients.collect(&:register_entry).group_by(&:organisation)
    @monitoring_entries_by_lobbyist_firm.each {|k,v| @monitoring_entries_by_lobbyist_firm[k] = v.sort_by{|x| x.data_source.period_start} }
    @monitoring_lobbyist_firm_keys = @monitoring_entries_by_lobbyist_firm.keys.sort_by(&:name)

    @similarly_named = @organisation.similarly_named
  end

  def edit
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
