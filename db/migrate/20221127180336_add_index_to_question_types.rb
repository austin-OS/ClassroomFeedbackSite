class AddIndexToQuestionTypes < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_question_types, :internal_name, unique: true
  end
end
