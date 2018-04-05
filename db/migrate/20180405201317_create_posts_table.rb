class CreatePostsTable < ActiveRecord::Migration[5.1]
  def change 
    create_table :posts do |t|
      t.string :title
      t.text :content, :limit => 150
      t.integer :user_id
    end
  end
end