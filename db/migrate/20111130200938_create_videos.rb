class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer  :viewable_id, :null => false
      t.string   :viewable_type, :limit => 50, :null => false
      t.string   :url, :null => false
      t.string   :title
      t.string   :thumbnail_url
      t.string   :thumbnail_width
      t.string   :thumbnail_height
      t.integer  :position
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
