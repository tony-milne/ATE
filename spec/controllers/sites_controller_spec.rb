require 'spec_helper'

describe SitesController do

  def mock_site(stubs={})
    @mock_site ||= mock_model(Site, stubs).as_null_object
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "assigns the requested site as @site" do
      Site.stub(:find).with("37") { mock_site }
      get :show, :id => "37"
      assigns(:site).should be(mock_site)
    end
  end

  describe "GET 'search'" do
    it "assigns the matching sites as @sites" do
      Site.stub(:search).with("bbc") { mock_site }
      get :search, :query => "bbc"
      assigns(:sites).should be(mock_site)
    end
  end

end
