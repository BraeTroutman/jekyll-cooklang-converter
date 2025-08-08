module Jekyll
  module Converters
    module Cooklang
      class Configuration
        DEFAULT_CONFIG = {
          "legacy_mode" => false,
          "css_classes" => {
            "ingredients_section" => "recipe-ingredients",
            "cookware_section" => "recipe-cookware",
            "steps_section" => "recipe-steps",
            "ingredient_list" => "ingredient-list",
            "cookware_list" => "cookware-list",
            "steps_list" => "steps-list",
            "quantity" => "quantity",
            "unit" => "unit",
            "name" => "name"
          },
          "headings" => {
            "ingredients" => "Ingredients",
            "cookware" => "Cookware",
            "steps" => "Steps"
          },
          "templates" => {
            "ingredient" => '<em class="<%= css_classes["quantity"] %>"><%= quantity %><%= unit.empty? ? "" : " " + unit %></em> <span class="<%= css_classes["name"] %>"><%= name %></span>',
            "cookware" => '<%= quantity.empty? ? "" : "<em class=\"" + css_classes["quantity"] + "\">" + quantity + "</em> " %><span class="<%= css_classes["name"] %>"><%= name %></span>',
            "timer" => '<em class="<%= css_classes["quantity"] %>"><%= quantity %> <%= unit %></em><%= name.empty? ? "" : " (" + name + ")" %>',
            "step" => "<%= content %>",
            "legacy_ingredient" => '<em><%= quantity %><%= unit.empty? ? "" : " " + unit %></em> <%= name %>',
            "legacy_cookware" => '<%= quantity.empty? ? "" : "<em>" + quantity + "</em> " %><%= name %>',
            "legacy_step" => "<p><%= content %></p>"
          }
        }.freeze

        attr_reader :config

        def initialize(site_config = {})
          @config = deep_merge(DEFAULT_CONFIG, site_config["cooklang"] || {})
        end

        def css_classes
          @config["css_classes"]
        end

        def headings
          @config["headings"]
        end

        def templates
          @config["templates"]
        end

        def legacy_mode?
          @config["legacy_mode"]
        end

        private

        def deep_merge(hash1, hash2)
          hash1.merge(hash2) do |key, oldval, newval|
            (oldval.is_a?(Hash) && newval.is_a?(Hash)) ? deep_merge(oldval, newval) : newval
          end
        end
      end
    end
  end
end
