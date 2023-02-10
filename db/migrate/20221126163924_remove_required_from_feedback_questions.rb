class RemoveRequiredFromFeedbackQuestions < ActiveRecord::Migration[7.0]
  def change
    # The "required" option will be consolidated with the other entries
    # in the FeedbackQuestionSettingsOptions table to streamline the design
    remove_column :feedback_questions, :required, :boolean
  end
end
