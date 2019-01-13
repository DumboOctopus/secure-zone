class CreateSafeWord < ActiveRecord::Migration[5.2]
  def change
    create_table :safe_words do |t|
      t.integer :degree
      t.integer :user_id
    end
  end
end
