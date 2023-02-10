module FeedbackFormsHelper
  include SessionsHelper
  ##
  # Sets @form_details instance variable to a hash containining all the
  # information associated with a feedback form needed for properly
  # generating the detailed views, including:
  #
  #   The top-level data fields from the FeedbackForm model, under
  #   the :form key
  #
  #   The list of questions, under the :question key
  #
  #   The lists of configuration settings applied to the questions, nested
  #   under each question entry with the :settings key
  #
  #   The list of all available settings options, under the
  #   :question_settings_options key
  #
  #   The lists of all available values of each settings option, nested
  #   under each option entry with the :values key
  #
  #   The list of question types, under the :question_types key
  #
  # If the id param is nil, only retrieve the latter three and leave the
  # former three blank
  #
  # Also sets the @form_details_json instance variable to the JSON
  # stringified version of @form_details for easier client-side
  # manipulation
  def get_form_details
    id = params[:id]

    # retrieve information specific to this form:
    # top-level form entry if ID is given
    form_record = (id.nil? ? {} : FeedbackForm.find(id))
    form = (id.nil? ? {} : form_record.attributes)
    # question list if ID is given
    question_records = (id.nil? ? [] : form_record.questions)
    questions = []
    # settings for each question
    question_records.each do |question|
      settings = question.settings
      question = question.attributes
      question[:settings] = settings
      questions.push(question)
    end

    # retrieve reference info:
    # list of options
    question_settings_option_records = FeedbackQuestionSettingsOption.all
    question_settings_options = []
    # lists of values for options
    question_settings_option_records.each do |option|
      values = option.values
      option = option.attributes
      option[:values] = values
      question_settings_options.push(option)
    end
    # list of question types
    question_type_records = FeedbackQuestionType.all
    question_types = []
    question_type_records.each do |type|
      question_types.push(type.attributes)
    end

    # save to hash and JSON
    @form_details = {
      form:,
      questions:,
      question_settings_options:,
      question_types:
    }
    @form_details_json = ActiveSupport::JSON.encode(@form_details)
  end

  ##
  # Takes received form_details_json param, parses from JSON, and saves
  # information to database, following the same format generated from
  # get_form_details.
  #
  # For the form entry and each question entry, a new record is created and
  # the new ID is stored in the foreign key fields of the associated
  # entities if the current ID is nil, otherwise update the existing entry
  # with the corresponding ID.
  #
  # If the form entry fails to save, re-render the current page and flash
  # the error messages. If the form itself saves but any of the associated
  # entities fail to save, render the edit page for the form (so as to
  # avoid duplicate creations on the next submission attempt) with the
  # unsaved changes still passed to the view so that the user doesn't lose
  # their work. If the form saves successfully, display a success message
  # and go back to the index page
  def save_form_details
    # retrieve and parse JSON string, convert keys from strings back to symbols
    @form_details = ActiveSupport::JSON.decode(params['form_details_json']).deep_symbolize_keys
    # Rails.logger.debug(@form_details.inspect)

    form_entry = @form_details[:form]
    form_questions = @form_details[:questions]

    # first attempt to save top-level form info
    form_params = ActionController::Parameters.new(form_entry).permit(:title)
    form_record = nil
    status = true
    isNewForm = form_entry[:id].nil?
    if isNewForm
      # case of creating new form
      form_record = FeedbackForm.new(form_params)
      status = form_record.save
    else
      # case of modifying existing form
      form_record = FeedbackForm.find(form_entry[:id])
      status = form_record.update(form_params)
    end

    # if successful, move on to trying to save questions
    if status
      form_entry[:id] = form_record.id # keep instance variables up-to-date in case page needs to be reloaded after partial save failure
      form_questions.each do |question_entry|
        question_entry[:form_id] = form_record.id # update association if necessary
        question_params = ActionController::Parameters.new(question_entry).permit(:question_text, :form_id, :type_id,
                                                                                  :order)

        if question_entry[:id].nil?
          # case of adding new question
          question_record = FeedbackQuestion.new(question_params)
          status = question_record.save
        else
          # case of updating existing question
          question_record = FeedbackQuestion.find(question_entry[:id])
          status = question_record.update(question_params)
        end

        # if successful, move on to trying to save question settings
        if status
          question_entry[:id] = question_record.id
          question_entry[:settings].each do |settings_entry|
            settings_entry[:question_id] = question_record.id # update association if necessary
            settings_params = ActionController::Parameters.new(settings_entry).permit(:question_id, :option_id, :value)

            if settings_entry[:id].nil?
              # case of adding new settings entry
              settings_record = FeedbackQuestionSetting.new(settings_params)
              status = settings_record.save
            else
              # case of updating existing settings entry
              settings_record = FeedbackQuestionSetting.find(settings_entry[:id])
              status = settings_record.update(settings_params)
            end

            # if unsuccessful, report error and stop
            next if status

            flash.now[:danger] =
              "Partial save failure - encountered errors while saving question settings to database. The follow errors were given: #{settings.record.errors}"
            render 'edit'
            break
          end
        else
          # otherwise, report error and stop
          flash.now[:danger] =
            "Partial save failure - encountered errors while saving questions to database. The following errors were given: #{question_record.errors}"
          render 'edit'
          break
        end
      end

      # delete questions that have been removed in the frontend
      if status
        form_record.questions.each do |question|
          question.destroy unless form_questions.map { |q| q[:id] }.include?(question.id)
        end
        # if the method has reached this point, then the save has succeeded
        # show success message and go to preview
        flash[:success] = "Form '#{form_record.title}' saved successfully"
        redirect_to feedback_form_path(id: form_record.id)
      end
    else
      # otherwise, report error and stop
      flash.now[:danger] = "Failed to save form to database. The following errors were given: #{form_record.errors}"
      render(isNewForm ? 'new' : 'edit')
    end
  end
end
