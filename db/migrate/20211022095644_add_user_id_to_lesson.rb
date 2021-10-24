class AddUserIdToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :user_id, :integer
  end
end
