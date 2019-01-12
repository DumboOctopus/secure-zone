class RenameColumnPicture < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :picture, :picture_url  
  end
end
