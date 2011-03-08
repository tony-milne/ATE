class AddMetaContentTypeToBookmark < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :meta_content_type, :string
  end

  def self.down
    remove_column :bookmarks, :meta_content_type
  end
end
