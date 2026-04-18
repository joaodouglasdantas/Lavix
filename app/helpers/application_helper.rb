module ApplicationHelper
  # Formata valores como BRL no padrão brasileiro
  def brl(amount)
    number_to_currency(amount, unit: "R$", separator: ",", delimiter: ".", format: "%u %n")
  end

  # Pequeno pontinho colorido usado para destacar categorias
  def category_dot(category, size: 10)
    content_tag(:span, "", class: "dot",
                style: "background-color: #{category.color}; width:#{size}px; height:#{size}px;")
  end
end
