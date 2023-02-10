class FeedbackResponsesController < ApplicationController
  include FeedbackFormsHelper # for #new action
  include FeedbackAssignmentsHelper # for #new action (minor usage)

  # add this line to prevent CRSF error when calling route from JS
  protect_from_forgery with: :null_session

  # Prepare to display list of received responses for given form,
  # possibly also limiting results to a given presentation
  def index
    # Page will be rendered on server-side, so any additional details
    # can be retrieved later
    # The process of filtering which responses are visible to the user is
    # handled by helpers called in the view
    @form = FeedbackForm.find(params[:form_id])
    @presentation = (params[:presentation_id] ? Presentation.find(params[:presentation_id]) : nil)
  end

  # Prepare to render screen for filling out form
  # Will need to retrieve details about the form questions and
  # settings, as well as the current assigned copy of the form
  # to pass to the frontend
  def new
    assignment = FeedbackAssignment.find(params[:assignment_id])
    params[:id] = assignment.form.id # prepare to call get_form_details
    get_form_details # form/question info now stored in @form_details
    @assignment_id =  assignment.id # record ID of form assignment for usage later when submitting form
    @presenter_name = "#{assignment.presentation.name} (#{presenter_names(assignment.presentation)})" # to make the interface for informative
  end

  # Submit form responses obtained from filling out form
  def create
    # get form assigment ID from params to determine how to associate responses
    assignment_id = params[:assignment_id]
    # get response values
    responses = ActiveSupport::JSON.decode(params[:responses])
    # set entry for each question responded to
    responses.each do |response|
      # update if assignment and question combo already present
      # create new otherwise
      response_params = { assigned_copy_id: assignment_id, question_id: response['question_id'] }
      response_record = FeedbackResponse.where(response_params).first
      response_params[:value] = response['value']
      if response_record
        response_record.update(response_params)
      else
        FeedbackResponse.create!(response_params) # if an operation this simple fails, just let the app crash
      end
    end

    flash[:success] = 'Form successfully submitted'
    redirect_to feedback_assignments_path
  end
end
