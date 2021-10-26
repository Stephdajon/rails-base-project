class RemoveColumnToLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :user_id
  end
end
