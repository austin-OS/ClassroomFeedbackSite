##
# Created by Thomas Li
# Originally generated 25 November 2022
# Last modified 28 November 2022
#
# This model contains an entry for each configuration setting that has
# been applied to a question on a feedback forms.
#
# Aside of the auto-generated ID and timestamp, the following fields are
# present:
#
#   question_id - integer (required)
#     Foreign key into the FeedbackQuestion model, to indicate which
#     question the setting is being applied to
#
#   option_id - integer (required)
#     Foreign key into the FeedbackQuestionSettingsOption model, to
#     indicate which option is being set.
#
#     The question ID and option ID together form a unique index. The
#     question ID on its own is a non-unique index.
#
#   value - integer
#     Value being applied. Can be any integer for quantitative options,
#     needs to be a foreign key into the FeedbackQuestionSettingsValue
#     model for non-quantitative options. Set to nil to revert to default
#
# Helper class for running complex validations
class FeedbackQuestionSettingsValidator < ActiveModel::Validator
  def validate(record)
    # If the view and controller are designed right then these shouldn't
    # have to be invoked

    # Check for type mismatches between given question and given option
    question_type = record.question.type
    option_question_type = record.option.question_type
    # nil type on option entry means option is applicable to any type
    if !option_question_type.nil? && question_type.id != option_question_type.id
      record.errors.add :base,
                        "Attempted to apply setting to question of improper type (given type for question: #{question_type.internal_name}, given type for option: #{option_question_type.internal_name}"
    end

    # Check that given value is an ID of a valid corresponding entry in the
    # values table if the option is qualitative
    unless record.option.quantitative
      value_entry = FeedbackQuestionSettingsValue.find(record.value)
      if value_entry.nil?
        record.errors.add :base,
                          "Attempted to set qualitative-valued option to value not present in values table (given value: #{value})"
      else
        value_option_entry = value_entry.option
        given_option_entry = record.option
        if value_option_entry.id != given_option_entry.id
          record.errors.add :base,
                            "Given settings value (#{value_entry.internal_name}, applicable for #{value_option_entry.internal_name}) doesn't match settings option (#{given_option_entry.internal_name})"
        end
      end
    end
  end
end

class FeedbackQuestionSetting < ApplicationRecord
  # Set associations for foreign keys
  belongs_to :question, class_name: 'FeedbackQuestion'
  belongs_to :option, class_name: 'FeedbackQuestionSettingsOption'

  # Validate presence of required fields
  validates :question_id, presence: true
  validates :option_id, presence: true
  # Additional, more complex validations
  validates_with FeedbackQuestionSettingsValidator
end
