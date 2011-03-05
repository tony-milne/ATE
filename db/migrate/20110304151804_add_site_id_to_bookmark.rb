class AddSiteIdToBookmark < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :site_id, :integer
  end

  def self.down
    remove_column :bookmarks, :site_id
  end
end
