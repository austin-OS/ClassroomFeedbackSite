module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'FeedBacker'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # To prevent certain characters from breaking the JSON parsing
  # Adapted from https://stackoverflow.com/a/21397142
  def escape_characters_in_string(string)
    pattern = %r{('|"|\.|\*|/|-|\\|\)|\$|\+|\(|\^|\?|!|~|`)}
    string.gsub(pattern) { |match| '\\' + match }
  end
end
