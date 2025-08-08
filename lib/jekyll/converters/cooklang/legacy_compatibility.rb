module Jekyll
  module Converters
    class ToHTML
      def to_html
        "<em>hello world</em>"
      end

      def to_list_item
        "<li>#{to_html}</li>"
      end
    end

    class Ingredient < ToHTML
      def initialize(quantity, unit, name)
        @formatter = Cooklang::Formatters::IngredientFormatter.new({
          "quantity" => quantity,
          "units" => unit,
          "name" => name
        }, nil)
        @data = @formatter.to_hash
      end

      def to_html
        return "<em>#{@data[:quantity]}</em> #{@data[:name]}" if @data[:unit].empty?
        "<em>#{@data[:quantity]} #{@data[:unit]}</em> #{@data[:name]}"
      end
    end

    class Timer < ToHTML
      def initialize(quantity, unit, name)
        @formatter = Cooklang::Formatters::TimerFormatter.new({
          "quantity" => quantity,
          "units" => unit,
          "name" => name
        }, nil)
        @data = @formatter.to_hash
      end

      def to_html
        return "<em>#{@data[:quantity]} #{@data[:unit]}</em>" if @data[:name].empty?
        "<em>#{@data[:quantity]} #{@data[:unit]}</em> (#{@data[:name]})"
      end
    end

    class CookWare < ToHTML
      def initialize(quantity, name)
        @formatter = Cooklang::Formatters::CookwareFormatter.new({
          "quantity" => quantity,
          "name" => name
        }, nil)
        @data = @formatter.to_hash
      end

      def to_html
        return @data[:name].to_s if @data[:quantity].empty?
        "<em>#{@data[:quantity]}</em> #{@data[:name]}"
      end
    end

    class OrderedList < ToHTML
      def initialize(items)
        @items = items
      end

      def to_html
        list_items = @items.map do |item|
          item.to_list_item
        end
        "<ol>" + list_items.join + "</ol>"
      end
    end

    class UnorderedList < ToHTML
      def initialize(items)
        @items = items
      end

      def to_html
        list_items = @items.map do |item|
          item.to_list_item
        end
        "<ul>" + list_items.join + "</ul>"
      end
    end

    class Step < ToHTML
      def initialize(step)
        @formatter = Cooklang::Formatters::StepFormatter.new(step, nil)
        @data = @formatter.to_hash
      end

      def to_html
        "<p>#{@data[:content]}</p>"
      end
    end
  end
end
