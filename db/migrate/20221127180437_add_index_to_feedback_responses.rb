class AddIndexToFeedbackResponses < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_responses, %i[assigned_copy_id question_id], unique: true
    add_index :feedback_responses, :question_id
    add_index :feedback_responses, :assigned_copy_id
  end
end
