class CreateVerses < ActiveRecord::Migration
  def change
    create_table :verses do |t|
      t.integer :strong_id
      t.integer :weak_id

      t.timestamps null: false
    end
  end
end
