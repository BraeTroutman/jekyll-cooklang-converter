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
        @name = name.to_s
        @unit = unit.to_s
        @quantity = if quantity.respond_to? :rationalize
          if quantity.rationalize(0.05).denominator == 1
            quantity.to_s
          else
            quantity.rationalize(0.05).to_s
          end
        else
          quantity.to_s
        end
      end

      def to_html
        return "<em>#{@quantity}</em> #{@name}" if @unit.empty?
        "<em>#{@quantity} #{@unit}</em> #{@name}"
      end
    end

    class Timer < ToHTML
      def initialize(quantity, unit, name)
        @name = name.to_s
        @unit = unit.to_s
        @quantity = quantity.to_s
      end

      def to_html
        return "<em>#{@quantity} #{@unit}</em>" if @unit.empty?
        "<em>#{@quantity} #{@unit}</em> (#{@name})"
      end
    end

    class CookWare < ToHTML
      def initialize(quantity, name)
        @name = name.to_s
        @quantity = quantity.to_s
      end

      def to_html
        return @name.to_s if @quantity.empty?
        "<em>#{@quantity}</em> #{@name}"
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
        @text = step.map do |substep|
          case substep["type"]
          when "cookware"
            substep["name"]
          when "ingredient"
            substep["name"]
          when "timer"
            "#{substep["quantity"]} #{substep["units"]}"
          when "text"
            substep["value"]
          end
        end.join
      end

      def to_html
        "<p>#{@text}</p>"
      end
    end

    class CooklangConverter < Converter
      safe true

      def matches(ext)
        ext =~ /^.cook/i
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        recipe = CooklangRb::Recipe.from(content)

        ingredients = recipe["steps"].flatten.select { |item|
          item["type"] == "ingredient"
        }.map { |item|
          Ingredient.new(item["quantity"], item["units"], item["name"])
        }

        cookware = recipe["steps"].flatten.select { |item|
          item["type"] == "cookware"
        }.map { |item|
          CookWare.new(item["quantity"], item["name"])
        }

        steps = recipe["steps"].map do |step|
          Step.new(step)
        end

        ingredients_list = UnorderedList.new(ingredients)
        cookware_list = UnorderedList.new(cookware)
        steps_list = OrderedList.new(steps)

        HtmlBeautifier.beautify(
          "<h2>Ingredients</h2>" +
            ingredients_list.to_html +
            "<h2>Cookware</h2>" +
            cookware_list.to_html +
            "<h2>Steps</h2>" +
            steps_list.to_html
        ) + "\n"
      end
    end
  end
end
