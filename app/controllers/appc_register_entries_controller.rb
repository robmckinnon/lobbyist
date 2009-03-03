class AppcRegisterEntriesController < ApplicationController

  def new
    @appc_register_entry = AppcRegisterEntry.new
  end
end
