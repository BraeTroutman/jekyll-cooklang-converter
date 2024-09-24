module Jekyll
  module Converters
    class CooklangConverter < Converter
      safe true

      def matches(ext)
        ext =~ /^.cook/i
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        content.upcase
      end
    end
  end
end
