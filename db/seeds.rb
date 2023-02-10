require 'faker'

User.create!(name:  "Professor #{Faker::Name.first_name}",
             email: "admin@email.com",
             password:              "adminpass22",
             password_confirmation: "adminpass22",
             admin: true)

# Generate a bunch of additional users.
30.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  name = first_name + " " + last_name
  puts name
  email = first_name + "." + last_name + "@osu.edu"
  puts email
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# Question types:
#   SCALE
#   TEXT
type_scale = FeedbackQuestionType.create!(internal_name: 'SCALE',
                                          descriptor: 'Numeric Scale', quantitative: true)
type_text = FeedbackQuestionType.create!(internal_name: 'TEXT', descriptor: 'Written Response', quantitative: false)

# Question settings:
#   For all question types:
#     REQUIRED (TRUE, FALSE (default))
#     RELEASE_TO (PRESENTERS_ONLY, INSTRUCTORS_ONLY,
#       PRESENTERS_AND_INSTRUCTORS (default), EVERYBODY)
#     DEANONMYMIZATION (NOBODY, PRESENTERS_ONLY, INSTRUCTORS_ONLY (default),
#       PRESENTERS_AND_INSTRUCTORS, EVERYBODY)
option_required = FeedbackQuestionSettingsOption.create!(
  question_type_id: nil,
  internal_name: 'REQUIRED',
  descriptor: 'Make this question required?',
  quantitative: false,
  default: nil
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_required.id,
  internal_name: 'TRUE',
  descriptor: 'Yes'
)
option_required_value_false = FeedbackQuestionSettingsValue.create!(
  option_id: option_required.id,
  internal_name: 'FALSE',
  descriptor: 'No'
)
option_required.default = option_required_value_false.id
option_required.save
option_release_to = FeedbackQuestionSettingsOption.create!(
  question_type_id: nil,
  internal_name: 'RELEASE_TO',
  descriptor: 'Who should be able to see the responses to this question once the form results are released to them?',
  quantitative: false,
  default: nil
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_release_to.id,
  internal_name: 'PRESENTERS_ONLY',
  descriptor: 'Only the presenters being evaluated'
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_release_to.id,
  internal_name: 'INSTRUCTORS_ONLY',
  descriptor: 'Only the instructors/graders in this course'
)
option_release_to_value_presenters_and_instructors = FeedbackQuestionSettingsValue.create!(
  option_id: option_release_to.id,
  internal_name: 'PRESENTERS_AND_INSTRUCTORS',
  descriptor: 'The instructors/graders as well as the presenters'
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_release_to.id,
  internal_name: 'EVERYBODY',
  descriptor: 'Anybody enrolled in this course who receives the results of this form'
)
option_release_to.default = option_release_to_value_presenters_and_instructors.id
option_release_to.save
option_deanonymization = FeedbackQuestionSettingsOption.create!(
  question_type_id: nil,
  internal_name: 'DEANONYMIZATION',
  descriptor: 'Among those who can see the results, who should be able to see which users submitted which responses?',
  quantitative: false,
  default: nil
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_deanonymization.id,
  internal_name: 'NOBODY',
  descriptor: 'Nobody'
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_deanonymization.id,
  internal_name: 'PRESENTERS_ONLY',
  descriptor: 'Only the presenters'
)
option_deanonymization_value_instructors_only = FeedbackQuestionSettingsValue.create!(
  option_id: option_deanonymization.id,
  internal_name: 'INSTRUCTORS_ONLY',
  descriptor: 'Only the instructors/graders'
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_deanonymization.id,
  internal_name: 'PRESENTERS_AND_INSTRUCTORS',
  descriptor: 'Any instructors/graders or presenters'
)
FeedbackQuestionSettingsValue.create!(
  option_id: option_deanonymization.id,
  internal_name: 'EVERYBODY',
  descriptor: 'Anybody who receives the responses to this question'
)
option_deanonymization.default = option_deanonymization_value_instructors_only.id
option_deanonymization.save!
#   For SCALE questions:
#     MIN_VALUE (quantitative, default 0)
#     MAX_VALUE (quantitative, default 5)
FeedbackQuestionSettingsOption.create!(
  question_type_id: type_scale.id,
  internal_name: 'MIN_VALUE',
  descriptor: 'Set the minimum allowable value:',
  quantitative: true,
  default: 0
)
FeedbackQuestionSettingsOption.create!(
  question_type_id: type_scale.id,
  internal_name: 'MAX_VALUE',
  descriptor: 'Set the maximum allowable value:',
  quantitative: true,
  default: 5
)
#   For TEXT questions:
#     MIN_LENGTH (quantitative, default 0)
#     MAX_LENGTH (quantitative, default nil)
FeedbackQuestionSettingsOption.create!(
  question_type_id: type_text.id,
  internal_name: 'MIN_LENGTH',
  descriptor: 'Set the minimum allowable response length in characters:',
  quantitative: true,
  default: 0
)
FeedbackQuestionSettingsOption.create!(
  question_type_id: type_text.id,
  internal_name: 'MAX_LENGTH',
  descriptor: 'Set the maximum allowable response length in characters (leave blank to allow unlimited length):',
  quantitative: true,
  default: nil
)
