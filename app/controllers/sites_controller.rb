class SitesController < ApplicationController
  def index
    @sites = Site.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @sites }
    end
  end

  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @site }
    end
  end

end
