module Jekyll
  module Converters
    module Cooklang
      class RecipeParser
        def initialize(config)
          @config = config
        end

        def parse(content)
          recipe = CooklangRb::Recipe.from(content)

          {
            ingredients: extract_ingredients(recipe),
            cookware: extract_cookware(recipe),
            steps: extract_steps(recipe)
          }
        rescue => e
          raise "Error parsing recipe: #{e.message}"
        end

        private

        def extract_ingredients(recipe)
          recipe["steps"].flatten
            .select { |item| item["type"] == "ingredient" }
            .map { |item| Formatters::IngredientFormatter.new(item, @config).to_hash }
        end

        def extract_cookware(recipe)
          recipe["steps"].flatten
            .select { |item| item["type"] == "cookware" }
            .map { |item| Formatters::CookwareFormatter.new(item, @config).to_hash }
        end

        def extract_steps(recipe)
          recipe["steps"].map { |step| Formatters::StepFormatter.new(step, @config).to_hash }
        end
      end
    end
  end
end
