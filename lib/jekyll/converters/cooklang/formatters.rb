module Jekyll
  module Converters
    module Cooklang
      module Formatters
        class QuantityFormatter
          def self.format(quantity)
            return quantity.to_s unless quantity.respond_to?(:rationalize)

            rationalized = quantity.rationalize(0.05)
            (rationalized.denominator == 1) ? quantity.to_s : rationalized.to_s
          end
        end

        class BaseFormatter
          attr_reader :data, :config

          def initialize(data, config)
            @data = data
            @config = config
          end

          def to_hash
            raise NotImplementedError, "Subclasses must implement to_hash"
          end
        end

        class IngredientFormatter < BaseFormatter
          def to_hash
            {
              quantity: QuantityFormatter.format(data["quantity"] || ""),
              unit: data["units"] || "",
              name: data["name"] || "",
              type: "ingredient"
            }
          end
        end

        class CookwareFormatter < BaseFormatter
          def to_hash
            {
              quantity: data["quantity"]&.to_s || "",
              name: data["name"] || "",
              type: "cookware"
            }
          end
        end

        class TimerFormatter < BaseFormatter
          def to_hash
            {
              quantity: data["quantity"]&.to_s || "",
              unit: data["units"] || "",
              name: data["name"] || "",
              type: "timer"
            }
          end
        end

        class StepFormatter < BaseFormatter
          def to_hash
            content = data.map do |substep|
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

            {
              content: content,
              type: "step"
            }
          end
        end
      end
    end
  end
end
