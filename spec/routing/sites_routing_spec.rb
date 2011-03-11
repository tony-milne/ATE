require "spec_helper"

describe SitesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sites" }.should route_to(:controller => "sites", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/sites/1" }.should route_to(:controller => "sites", :action => "show", :id => "1")
    end

    it "recognizes and generates #search" do
      { :get => "/sites/search" }.should route_to(:controller => "sites", :action => "search")
    end

  end
end
