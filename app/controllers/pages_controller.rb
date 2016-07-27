class PagesController < ApplicationController
  	skip_before_action :authenticate_tenant!, :only => [ :home, :about ]

	def index
	end

	def about
	end

end
