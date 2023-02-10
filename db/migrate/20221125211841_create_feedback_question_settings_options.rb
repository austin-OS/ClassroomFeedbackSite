class CreateFeedbackQuestionSettingsOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_question_settings_options do |t|
      t.integer :question_type_id
      t.string :internal_name
      t.string :descriptor
      t.boolean :quantitative

      t.timestamps
    end
  end
end
