class AddAvailabilityDateToFeedbackAssignments < ActiveRecord::Migration[7.0]
  def change
    add_column :feedback_assignments, :availability_date, :date
  end
end
