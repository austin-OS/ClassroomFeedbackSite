class CreateFeedbackQuestionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_question_types do |t|
      t.string :internal_name
      t.string :descriptor
      t.boolean :quantitative

      t.timestamps
    end
  end
end
