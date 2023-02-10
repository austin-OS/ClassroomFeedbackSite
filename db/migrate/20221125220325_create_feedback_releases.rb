class CreateFeedbackReleases < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_releases do |t|
      t.integer :form_id
      t.integer :recipient_id
      t.boolean :anonymized
      t.date :release_time

      t.timestamps
    end
  end
end
