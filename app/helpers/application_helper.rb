module ApplicationHelper
  def category_icon(category_name)
    case category_name.downcase
    when /women/i
      "bi-person-dress"
    when /men/i
      "bi-person"
    when /accessory/i, /accessories/i
      "bi-gem"
    when /bridal/i, /wedding/i
      "bi-hearts"
    else
      "bi-bag-heart"
    end
  end
end
