class AddPresentationIdToFeedbackAssignment < ActiveRecord::Migration[7.0]
  def change
    add_column :feedback_assignments, :presentation_id, :integer

    # now that all columns are in place, add indices
    add_index :feedback_assignments, %i[form_id presentation_id evaluator_id], unique: true,
                                                                               name: 'uniq_evaluator_per_presentation_per_form'
    add_index :feedback_assignments, :form_id
    add_index :feedback_assignments, :presentation_id
    add_index :feedback_assignments, :evaluator_id
  end
end
