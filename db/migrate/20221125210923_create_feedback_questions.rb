class CreateFeedbackQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_questions do |t|
      t.string :question_text
      t.integer :form_id
      t.integer :type_id
      t.integer :order
      t.boolean :required

      t.timestamps
    end
  end
end
