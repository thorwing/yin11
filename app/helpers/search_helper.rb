module SearchHelper
  def get_subject(item)
    if item.respond_to?(:name)
      subject = item.name
    elsif item.respond_to?(:title)
      subject = item.title
    else
      subject = ''
    end

    subject
  end

  def get_content(item)
    if item.respond_to?(:content)
      subject = item.content
    elsif item.respond_to?(:description)
      subject = item.description
    else
      subject = ''
    end

    subject
  end
end