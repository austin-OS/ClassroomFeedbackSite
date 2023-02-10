class AddIndexToFeedbackQuestions < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_questions, :form_id
  end
end
