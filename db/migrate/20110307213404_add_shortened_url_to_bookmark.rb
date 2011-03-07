class AddShortenedUrlToBookmark < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :shortened_url, :string
  end

  def self.down
    remove_column :bookmarks, :shortened_url
  end
end
