require_relative "cooklang/configuration"
require_relative "cooklang/formatters"
require_relative "cooklang/renderers"
require_relative "cooklang/recipe_parser"
require_relative "cooklang/legacy_compatibility"

module Jekyll
  module Converters
    class CooklangConverter < Converter
      safe true

      def initialize(config = {})
        super
        @site_config = config.is_a?(Hash) ? config : {}
        # Initialize with empty config, will be overridden by Jekyll
        @cooklang_config = nil
        @parser = nil
        @renderer = nil
      end

      def setup
        return if @cooklang_config
        site_config = @config || {}
        @cooklang_config = Cooklang::Configuration.new(site_config)
        @parser = Cooklang::RecipeParser.new(@cooklang_config)
        @renderer = Cooklang::Renderers::HtmlRenderer.new(@cooklang_config)
      end

      def matches(ext)
        ext =~ /^.cook/i
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        setup

        recipe_data = @parser.parse(content)

        ingredients_html = render_ingredients_section(recipe_data[:ingredients])
        cookware_html = render_cookware_section(recipe_data[:cookware])
        steps_html = render_steps_section(recipe_data[:steps])

        full_html = ingredients_html + cookware_html + steps_html

        HtmlBeautifier.beautify(full_html) + "\n"
      rescue => e
        Jekyll.logger.error "Cooklang Converter:", "Failed to convert content: #{e.message}"
        raise
      end

      private

      def render_ingredients_section(ingredients)
        return "" if ingredients.empty?

        ingredient_items = ingredients.map { |ingredient| @renderer.render_ingredient(ingredient) }
        ingredients_list = @renderer.render_list(ingredient_items, "ul", @cooklang_config.css_classes["ingredient_list"])
        @renderer.render_section(@cooklang_config.headings["ingredients"], ingredients_list, @cooklang_config.css_classes["ingredients_section"])
      end

      def render_cookware_section(cookware)
        return "" if cookware.empty?

        cookware_items = cookware.map { |item| @renderer.render_cookware(item) }
        cookware_list = @renderer.render_list(cookware_items, "ul", @cooklang_config.css_classes["cookware_list"])
        @renderer.render_section(@cooklang_config.headings["cookware"], cookware_list, @cooklang_config.css_classes["cookware_section"])
      end

      def render_steps_section(steps)
        return "" if steps.empty?

        step_items = steps.map { |step| @renderer.render_step(step) }
        steps_list = @renderer.render_list(step_items, "ol", @cooklang_config.css_classes["steps_list"])
        @renderer.render_section(@cooklang_config.headings["steps"], steps_list, @cooklang_config.css_classes["steps_section"])
      end
    end
  end
end
