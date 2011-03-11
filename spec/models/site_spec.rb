require 'spec_helper'

describe Site do
  context "given that sites exist" do
    before(:each) do
      Bookmark.create!(:url => "http://www.alphasights.com/contact")
      Bookmark.create!(:url => "http://www.bridgenoble.com/")
    end

    it "should be searchable" do
      Site.search("alphasights").should == [] << Site.find_by_url("alphasights.com")
    end
  end
end
