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

  it "TODO parses successfully (actual HTML generation tested by clash)" do
    recipe_text = "do this to @ingredient{1%cup} with #some cookware{}\n" \
                  "do another thing with @other ingredient{2} with #item\n"
    expect(converter.convert(recipe_text)).to be_truthy
  end
end
