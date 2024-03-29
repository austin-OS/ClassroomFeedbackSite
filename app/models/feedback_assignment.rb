##
# Created by Thomas Li
# Originally generated 25 November 2022
# Last modified 30 November 2022
#
# This model contains one entry for each assigned copy of a feedback form
# that each evaluator is tasked with filling out for each presenter or
# presentation group
#
# Aside of the autogenerated ID and timestamps, the following fields are
# present:
#
#   form_id - integer (required)
#     Foreign key into feedback_form model, to track which form has been
#     assigned.
#
#   presentation_id : integer (required)
#     Foreign key into presentation model, to track which presentation
#     is being evaluated
#
#   evaluator_id - integer (required)
#     Foreign key into user model, to track which user the form has been
#     assigned to be filled out by. Any user can be assigned a form so
#     long as they are enrolled in the same course
#
#     The feedback form ID, presentation ID, and user ID form a unique
#     index, and each individually forms a non-unique index
#
#   availability_date - date
#     The time at which the evaluator will be able to access and complete
#     the form - set to nil for immediate availability
#
#   due_date - date
#     The deadline for completing the form, set to nil if the user has
#     unlimited time
#
class FeedbackAssignment < ApplicationRecord
  # Set associations for foreign keys
  belongs_to :form, class_name: 'FeedbackForm'
  belongs_to :presentation, class_name: 'Presentation'
  belongs_to :evaluator, class_name: 'User'

  # Create accessors for associated entities
  has_many :responses, class_name: 'FeedbackResponse', foreign_key: 'assigned_copy_id'

  # Validate presence of required fields
  validates :form_id, presence: true
  validates :evaluator_id, presence: true
  validates :presentation_id, presence: true
end
