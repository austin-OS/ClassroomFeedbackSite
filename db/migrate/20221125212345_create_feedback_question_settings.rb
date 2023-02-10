class CreateFeedbackQuestionSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_question_settings do |t|
      t.integer :question_id
      t.integer :option_id
      t.integer :value

      t.timestamps
    end
  end
end
