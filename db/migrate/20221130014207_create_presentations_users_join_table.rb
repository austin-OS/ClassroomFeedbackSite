class CreatePresentationsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :presentations do |t|
      t.index :user_id
      t.index :presentation_id
    end
  end
end
