require "jekyll"
require "jekyll-cooklang-converter"

describe Jekyll::Converters::CooklangConverter do
  let(:converter) { described_class.new }
  it "matches on .cook file extension" do
    expect(converter.matches(".cook")).to be_truthy
  end

  it "has proper output file extension" do
    expect(converter.output_ext("")).to eql(".html")
  end

  it "TODO parses properly" do
    recipe_text = "do this to @ingredient{1%cup} with #some cookware{}\n" \
                  "do another thing with @other ingredient{2} with #item\n"
    expect(converter.convert(recipe_text)).to eql(
      "<h2>Ingredients</h2>" \
      "<ul><li><em>1 cup</em> ingredient</li><li><em>2</em> other ingredient</li></ul>" \
      "<h2>Cookware</h2>" \
      "<ul><li><em>1</em> some cookware</li><li><em>1</em> item</li></ul>" \
      "<h2>Steps</h2>" \
      "<ol><li><p>do this to ingredient with some cookware</p></li><li><p>do another thing with other ingredient with item</p></li></ol>"
    )
  end
end
