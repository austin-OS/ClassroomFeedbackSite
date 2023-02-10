class CreateFeedbackAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_assignments do |t|
      t.integer :form_id
      t.integer :evaluator_id
      t.date :due_date

      t.timestamps
    end
  end
end
