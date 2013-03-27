class AddDelete < ActiveRecord::Migration
  def up
      change_table :words do |t|
          t.boolean :deleted
      end
      Word.update_all ["deleted = ?", false]
  end

  def down
      drop_table :words
  end
end
