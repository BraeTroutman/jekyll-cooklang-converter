require "jekyll"
require "jekyll-cooklang-converter"

describe Jekyll::Converters::CooklangConverter do
  it "matches on .cook file extension" do
    expect(Jekyll::Converters::CooklangConverter.new.matches(".cook")).to be_truthy
  end

  it "has proper output file extension" do
    expect(Jekyll::Converters::CooklangConverter.new.output_ext("")).to eql(".html")
  end

  it "outputs input to uppercase" do
    expect(Jekyll::Converters::CooklangConverter.new.convert("hello\n")).to eql("HELLO\n")
  end
end
