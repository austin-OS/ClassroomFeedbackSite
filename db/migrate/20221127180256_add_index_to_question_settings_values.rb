class AddIndexToQuestionSettingsValues < ActiveRecord::Migration[7.0]
  def change
    add_index :feedback_question_settings_values, %i[option_id internal_name], unique: true,
                                                                               name: 'uniq_internal_value_name_by_option'
    add_index :feedback_question_settings_values, :option_id
  end
end
