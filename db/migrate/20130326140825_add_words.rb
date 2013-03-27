class AddWords < ActiveRecord::Migration
  def up
      create_table :words do |t|
          t.string :word
          t.integer :count
          t.boolean :deleted
          t.timestamps
      end
  end

  def down
      drop_table :words
  end
end
