class AddMetaDescriptionToBookmark < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :meta_description, :string
  end

  def self.down
    remove_column :bookmarks, :meta_description
  end
end
