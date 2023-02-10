##
# Created by Thomas Li
#
# This controller handles actions for assigning copies of feedback forms
# to allow users to evaluate presentations
class FeedbackAssignmentsController < ApplicationController
  include SessionsHelper

  # add this line to prevent CRSF error when calling route from JS
  protect_from_forgery with: :null_session

  # Display all assigned forms - retrieve for everyone for instructor
  # retrieve for self if user
  def index
    # list of assignment entries
    @feedback_assignments = (current_user.admin ? FeedbackAssignment.all : FeedbackAssignment.where(evaluator_id: current_user.id))
    # indicate whether or not each assigned form has been submitted already
    @response_submitted = @feedback_assignments.to_h { |a| [a.id, a.responses.length > 0] }
  end

  # Get information to render page for assigning feedback
  def new
    @selected_form_id = params[:form_id] # option to have a form selected by default
    @selected_presentation_id = params[:presentation_id] # option to have a presentation selected by default
  end

  # Save information to DB
  def create
    # get info on which form is being assigned
    form_id = params[:form_id]
    # get info on which presentation is being assigned
    presentation_id = params[:presentation_id]
    # get info on which users are being assigned and select users
    user_ids = []
    case params[:assignment_option]
    when 'peers'
      user_ids = User.select do |u|
                   !u.admin && !u.presentations.include?(Presentation.find(presentation_id))
                 end.map { |u| u.id }
    when 'presenters'
      user_ids = User.select { |u| u.presentations.include?(Presentation.find(presentation_id)) }.map { |u| u.id }
    when 'instructors'
      user_ids = User.select { |u| u.admin }.map { |u| u.id }
    when 'everyone'
      user_ids = User.all.map { |u| u.id }
    when 'custom'
      user_ids = [params[:user_id]]
    end
    # create entries
    user_ids.each do |user_id|
      record_params = { form_id:, presentation_id:, evaluator_id: user_id }
      unless FeedbackAssignment.exists?(record_params)
        FeedbackAssignment.create!(record_params) # if record creation fails for something this simple, just let the program crash
      end
    end
    # display message, return to index page
    flash[:success] = 'Form successfully assigned'
    redirect_to feedback_assignments_path
  end

  # Unassign form
  def destroy
    form_assignment = FeedbackAssignment.find(params[:id])
    form_assignment.destroy
    flash[:success] = 'Form successfully unassigned'
    redirect_to feedback_assignments_path
  end
end
