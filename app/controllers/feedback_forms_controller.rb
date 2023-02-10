##
# Created by Thomas Li
class FeedbackFormsController < ApplicationController
  include FeedbackFormsHelper

  # add this line to prevent CRSF error when calling route from JS
  protect_from_forgery with: :null_session

  # all of these should check that the user has instructor priveliges,
  # and redirect if not

  # for the show, new, and edit actions, call helper to retrieve all
  # info associated with form and store in instance variable
  before_action :get_form_details, only: %i[show new edit]

  # for the create and update actions, call helper to save all received
  # information to the database, with entries created or updated based
  # on whether IDs are already present
  before_action :save_form_details, only: %i[create update]

  def index
    # pass a list containing top-level fields of all forms present
    # in the database to the view
    @feedback_forms = FeedbackForm.all
    @feedback_forms_json = ActiveSupport::JSON.encode(@feedback_forms)
  end

  def show
    # pass all information associated with the given form to the view,
    # including both the top-level fields and any nested information
    # about questions and question settings and reference info
    # (handled by helper)
  end

  def new
    # if the user opted to create the form as a copy of another form
    # retrieve all of the associated information just like with #show,
    # otherwise pass empty form to view
    # (handled by helper - nil ID param returns blank form)
    # for copies, replace retrieved IDs and title
    unless @form_details[:form]['id'].nil?
      @form_details[:form]['id'] = nil
      @form_details[:form]['title'] = "Copy of #{@form_details[:form]['title']}"
      @form_details[:questions].each do |question|
        question['id'] = nil
        question['form_id'] = nil
        question[:settings].each do |setting|
          setting['id'] = nil
          setting['question_id'] = nil
        end
      end
      @form_details_json = ActiveSupport::JSON.encode(@form_details)
    end
  end

  def create
    # save form info, questions, and question settings to database
    # (handled by helper)
  end

  def edit
    # pass detailed form information to view, same as with #show
    # (handled by helper)
  end

  def update
    # update form info, questions, and question settings, add any
    # new questions and delete questions that are no longer present
    # (handled by helper)
  end

  def destroy
    # delete specified form from database - whether to make this
    # cascade is something we'll decide on later
    form = FeedbackForm.find(params[:id])
    form_title = form.title
    form.destroy
    # redirect to forms index page, notify user of deletion
    flash[:success] = "Successfully deleted form '#{form_title}'"
    redirect_to feedback_forms_path
  end
end
