class CreateFeedbackQuestionSettingsValues < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_question_settings_values do |t|
      t.integer :option_id
      t.string :internal_name
      t.string :descriptor

      t.timestamps
    end
  end
end
