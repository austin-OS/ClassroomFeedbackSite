module FeedbackResponsesHelper
  # Returns the list of responses for the given presentation and form
  # question that "should" be visible to the user given the question
  # settings
  def filter_responses(presentation, question)
    all_responses = question.responses.select { |r| r.assigned_copy.presentation == presentation }
    (user_meets_criteria?(current_user, presentation, question, "RELEASE_TO") ? all_responses : [])
  end

  # Determines whether respondent identities are hidden from current user
  def responses_anonymized?(presentation, question)
    !user_meets_criteria?(current_user, presentation, question, "DEANONYMIZATION")
  end

  # Helper function for above two methods, taking advantage of reused
  # internal labels
  def user_meets_criteria?(user, presentation, question, settings_option_label)
    # Get internal name of current configured value
    # Set to default if none explicitly assigned
    settings_option = FeedbackQuestionSettingsOption.find_by(internal_name: settings_option_label)
    setting = question.settings.find_by(option_id: settings_option.id)
    setting_value = settings_option.values.find((setting.nil? ? settings_option.default : setting.value))
    setting_label = setting_value.internal_name

    # Evaluate
    is_presenter = presentation.users.include?(user)
    is_instructor = user.admin
    case setting_label
    when "NOBODY"
        false
    when "PRESENTERS_ONLY"
        is_presenter
    when "INSTRUCTORS_ONLY"
        is_instructor
    when "PRESENTERS_AND_INSTRUCTORS"
        is_presenter || is_instructor
    when "EVERYBODY"
        true
    end
  end
end
