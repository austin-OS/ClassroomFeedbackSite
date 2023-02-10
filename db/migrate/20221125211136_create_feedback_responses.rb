class CreateFeedbackResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_responses do |t|
      t.integer :assigned_copy_id
      t.integer :question_id
      t.string :value

      t.timestamps
    end
  end
end
