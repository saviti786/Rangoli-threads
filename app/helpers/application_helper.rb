module ApplicationHelper
  ICONS = {
    women:       "bi-person-dress",
    men:         "bi-person",
    accessories: "bi-gem",
    bridal:      "bi-hearts"
  }.freeze

  def category_icon(category_name)
    name = category_name.to_s.downcase
    return ICONS[:women] if name.match?(/women/)
    return ICONS[:men] if name.match?(/men/)
    return ICONS[:accessories] if name.match?(/accessory|accessories/)
    return ICONS[:bridal] if name.match?(/bridal|wedding/)

    "bi-bag-heart"
  end
end
