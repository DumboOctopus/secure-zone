class CreateTimeToRespond < ActiveRecord::Migration[5.2]
  def change
    create_table :time_to_responds do |t|
      t.integer :time
      t.integer :degree
    end
  end
end
