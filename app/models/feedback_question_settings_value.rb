##
# Created by Thomas Li
# Originally generated 25 November 2022
# Last modified 25 November 2022
#
# This model represents qualitative values that configuration options can
# take on.
#
# Aside of the autogenerated ID and timestamps, the following fields are
# present:
#
#   option_id : integer (required)
#       Foreign key into the FeedbackQuestionSettingsOption model, to
#       indicate which option the value can be applied to. Only options
#       with non-quantitative values are supported
#
#   internal_name : string (required)
#       A verbal identifier for internal use, all-uppercase by convention
#
#       The option ID and internal name together form a unique index, with
#       the option ID itself being a non-unique index
#
#   descriptor : string (required)
#       A reader-friendly name for external use
#
# This is intended to be a reference table, containing a limited set of
# of pre-seeded values that the FeedbackQuestionSettings table draws from,
# as opposed to be being populated by user actions. The following values
# are initialized in the seed script:
#
#   Values available for REQUIRED option:
#
#     internal_name: "TRUE"
#     descriptor: "Yes"
#
#     internal_name: "FALSE"
#     descriptor: "No"
#
#   Values available for RELEASE_TO option:
#
#     internal_name: "PRESENTERS_ONLY"
#     descriptor: "Only the presenters being evaluated"
#
#     internal_name: "INSTRUCTORS_ONLY"
#     descriptor: "Only the instructors/graders in this course"
#
#     internal_name: "PRESENTERS_AND_INSTRUCTORS"
#     descriptor: "The instructors/graders as well as the presenters"
#
#     internal_name: "EVERYBODY"
#     descriptor: "Everybody enrolled in this course"
#
# Values available for DEANONYMIZATION option:
#
#     internal_name: "NOBODY"
#     descriptor: "Nobody"
#
#     internal_name: "PRESENTERS_ONLY"
#     descriptor: "Only the presenters who receive the responses"
#
#     internal_name: "INSTRUCTORS_ONLY"
#     descriptor: "Only the instructors/graders who receive the responses"
#
#     internal_name: "PRESENTERS_AND_INSTRUCTORS"
#     descriptor: "The instructors/graders and presents who receive the
#     responses"
#
#     internal_name: "EVERYBODY"
#     descriptor: "Everyone who receives the responses"
#
class FeedbackQuestionSettingsValue < ApplicationRecord
  # Set associations for foreign keys
  belongs_to :option, class_name: 'FeedbackQuestionSettingsOption'

  # Validate presence of required fields
  validates :option_id, presence: true
  validates :internal_name, presence: true
  validates :descriptor, presence: true

  # Normalize internal name
  before_save { internal_name.upcase! }
end
