require 'spec_helper'

describe Bookmark do
  context "on bookmark creation" do
    it "links bookmark to site" do
      bookmark = Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera")
      Site.count.should == 1
    end

    it "passes validation with valid url" do
      Bookmark.new(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera").should have(0).errors_on(:url)
    end

    it "fails validation with no url" do
      Bookmark.new.should have(2).errors_on(:url)
    end

    it "fails validation with invalid url in invalid format" do
      Bookmark.new(:url => "invalid url").should have(1).errors_on(:url)
    end

    it "fails validation with blank url" do
      Bookmark.new(:url => "").should have(2).errors_on(:url)
    end

    it "fails validation with invalid url in valid format" do
      Bookmark.new(:url => "http://www.sdfasdfasdf.com").should have(1).errors_on(:url)
    end

    it "ensures uniqueness of bookmark" do
      Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera")
      Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera").should have(1).errors_on(:url)
    end

    it "gets a shortened url" do
      b = Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera")
      b.shortened_url.should == "http://tinyurl.com/4ak7eef"
    end

    it "gets the page title" do
      b = Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera")
      b.page_title.should == "Apple: You Must Be 17+ To Use Opera - Slashdot"
    end
    
    it "gets metadata" do
      b = Bookmark.create(:url => "http://idle.slashdot.org/story/11/03/04/1453241/Apple-You-Must-Be-17-To-Use-Opera")
      b.meta_content_type.should == "text/html; charset=utf-8"
    end
  end
end
