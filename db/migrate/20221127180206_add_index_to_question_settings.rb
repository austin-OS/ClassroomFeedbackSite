class AddIndexToQuestionSettings < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_question_settings, %i[question_id option_id], unique: true
    add_index :feedback_question_settings, :question_id
  end
end
