class AddDefaultToFeedbackQuestionSettingsOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :feedback_question_settings_options, :default, :integer
  end
end
