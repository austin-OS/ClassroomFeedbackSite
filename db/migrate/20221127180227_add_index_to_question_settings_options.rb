class AddIndexToQuestionSettingsOptions < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_question_settings_options, %i[question_type_id internal_name], unique: true,
                                                                                       name: 'uniq_internal_option_name_per_question_type'
    add_index :feedback_question_settings_options, :question_type_id
  end
end
