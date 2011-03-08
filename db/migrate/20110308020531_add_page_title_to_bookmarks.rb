class AddPageTitleToBookmarks < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :page_title, :string
  end

  def self.down
    remove_column :bookmarks, :page_title
  end
end
