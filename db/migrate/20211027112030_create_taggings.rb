class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end
