require "jekyll-cooklang-converter"

describe Jekyll::Converters::Ingredient do
  it "converts to HTML cleanly" do
    cream = Jekyll::Converters::Ingredient.new("1", "cup", "cream")
    expect(cream.to_html).to eql("<em>1 cup</em> cream")
  end
  it "ommits the unit when unspecified" do
    cream = Jekyll::Converters::Ingredient.new("1", "", "onion")
    expect(cream.to_html).to eql("<em>1</em> onion")
  end
  it "can be cast to a list item" do
    cream = Jekyll::Converters::Ingredient.new("1", "", "onion")
    expect(cream.to_list_item).to eql("<li><em>1</em> onion</li>")
  end
  it "rationalizes units when applicable" do
    cream = Jekyll::Converters::Ingredient.new(0.5, "cup", "cream")
    expect(cream.to_html).to eql("<em>1/2 cup</em> cream")
  end
  it "rationalizes units when applicable" do
    cream = Jekyll::Converters::Ingredient.new(0.25, "cup", "cream")
    expect(cream.to_html).to eql("<em>1/4 cup</em> cream")
  end
end

describe Jekyll::Converters::CookWare do
  it "converts to HTML cleanly" do
    sheet_pan = Jekyll::Converters::CookWare.new("1", "sheet pan")
    expect(sheet_pan.to_html).to eql("<em>1</em> sheet pan")
  end
  it "ommits the quanity when not present" do
    sheet_pan = Jekyll::Converters::CookWare.new("", "sheet pan")
    expect(sheet_pan.to_html).to eql("sheet pan")
  end
  it "can be cast to a list item" do
    sheet_pan = Jekyll::Converters::CookWare.new("1", "sheet pan")
    expect(sheet_pan.to_list_item).to eql("<li><em>1</em> sheet pan</li>")
  end
end

describe Jekyll::Converters::OrderedList do
  it "becomes valid HTML" do
    ingredient_list = Jekyll::Converters::OrderedList.new([
      Jekyll::Converters::Ingredient.new("1", "scoop", "ice cream"),
      Jekyll::Converters::Ingredient.new("2", "", "bananas")
    ])
    expect(ingredient_list.to_html).to eql("<ol><li><em>1 scoop</em> ice cream</li><li><em>2</em> bananas</li></ol>")
  end
end

describe Jekyll::Converters::UnorderedList do
  it "becomes valid HTML" do
    ingredient_list = Jekyll::Converters::UnorderedList.new([
      Jekyll::Converters::Ingredient.new("1", "scoop", "ice cream"),
      Jekyll::Converters::Ingredient.new("2", "", "bananas")
    ])
    expect(ingredient_list.to_html).to eql("<ul><li><em>1 scoop</em> ice cream</li><li><em>2</em> bananas</li></ul>")
  end
end

describe Jekyll::Converters::Timer do
  it "becomes valid HTML" do
    timer = described_class.new("10", "minutes", "casserole")
    expect(timer.to_html).to eql("<em>10 minutes</em> (casserole)")
  end
end

describe Jekyll::Converters::Step do
  it "becomes valid HTML" do
    step = Jekyll::Converters::Step.new([
      {
        "type" => "text",
        "value" => "fold in the "
      },
      {
        "type" => "ingredient",
        "name" => "cheese",
        "quantity" => "1",
        "unit" => "cup"
      }
    ])
    expect(step.to_html).to eql("<p>fold in the cheese</p>")
  end
end
