module FeedbackAssignmentsHelper
  def presenter_names(presentation)
    presentation.users.map { |u| u.name }.join(', ')
  end
end
