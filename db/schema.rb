# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_221_201_042_644) do
  create_table 'feedback_assignments', force: :cascade do |t|
    t.integer 'form_id'
    t.integer 'evaluator_id'
    t.date 'due_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.date 'availability_date'
    t.integer 'presentation_id'
    t.index ['evaluator_id'], name: 'index_feedback_assignments_on_evaluator_id'
    t.index %w[form_id presentation_id evaluator_id], name: 'uniq_evaluator_per_presentation_per_form',
                                                      unique: true
    t.index ['form_id'], name: 'index_feedback_assignments_on_form_id'
    t.index ['presentation_id'], name: 'index_feedback_assignments_on_presentation_id'
  end

  create_table 'feedback_forms', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'feedback_groups', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'feedback_question_settings', force: :cascade do |t|
    t.integer 'question_id'
    t.integer 'option_id'
    t.integer 'value'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[question_id option_id], name: 'index_feedback_question_settings_on_question_id_and_option_id',
                                       unique: true
    t.index ['question_id'], name: 'index_feedback_question_settings_on_question_id'
  end

  create_table 'feedback_question_settings_options', force: :cascade do |t|
    t.integer 'question_type_id'
    t.string 'internal_name'
    t.string 'descriptor'
    t.boolean 'quantitative'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'default'
    t.index %w[question_type_id internal_name], name: 'uniq_internal_option_name_per_question_type', unique: true
    t.index ['question_type_id'], name: 'index_feedback_question_settings_options_on_question_type_id'
  end

  create_table 'feedback_question_settings_values', force: :cascade do |t|
    t.integer 'option_id'
    t.string 'internal_name'
    t.string 'descriptor'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[option_id internal_name], name: 'uniq_internal_value_name_by_option', unique: true
    t.index ['option_id'], name: 'index_feedback_question_settings_values_on_option_id'
  end

  create_table 'feedback_question_types', force: :cascade do |t|
    t.string 'internal_name'
    t.string 'descriptor'
    t.boolean 'quantitative'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['internal_name'], name: 'index_feedback_question_types_on_internal_name', unique: true
  end

  create_table 'feedback_questions', force: :cascade do |t|
    t.string 'question_text'
    t.integer 'form_id'
    t.integer 'type_id'
    t.integer 'order'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['form_id'], name: 'index_feedback_questions_on_form_id'
  end

  create_table 'feedback_releases', force: :cascade do |t|
    t.integer 'form_id'
    t.integer 'recipient_id'
    t.boolean 'anonymized'
    t.date 'release_time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'feedback_responses', force: :cascade do |t|
    t.integer 'assigned_copy_id'
    t.integer 'question_id'
    t.string 'value'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[assigned_copy_id question_id], name: 'index_feedback_responses_on_assigned_copy_id_and_question_id',
                                              unique: true
    t.index ['assigned_copy_id'], name: 'index_feedback_responses_on_assigned_copy_id'
    t.index ['question_id'], name: 'index_feedback_responses_on_question_id'
  end

  create_table 'presentations', force: :cascade do |t|
    t.string 'name'
    t.date 'date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'presentations_users', id: false, force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'presentation_id', null: false
    t.index ['presentation_id'], name: 'index_presentations_users_on_presentation_id'
    t.index ['user_id'], name: 'index_presentations_users_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'role'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'password_digest'
    t.boolean 'admin', default: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
