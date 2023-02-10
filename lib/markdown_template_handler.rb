require Rails.root.join("lib", "markdown_template_handler")
ActionView::Template.register_template_handler(:md, MarkdownTemplateHandler.new)

class MarkdownTemplateHandler
  def call(template)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    "#{markdown.render(template.source).inspect}.html_safe;"
  end
end