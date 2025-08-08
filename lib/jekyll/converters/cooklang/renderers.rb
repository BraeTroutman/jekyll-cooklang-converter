require "erb"

module Jekyll
  module Converters
    module Cooklang
      module Renderers
        class TemplateRenderer
          def initialize(config)
            @config = config
          end

          def render(template_name, data)
            template = @config.templates[template_name.to_s]
            return "" unless template

            erb = ERB.new(template)
            context = RenderContext.new(data, @config)
            erb.result(context.get_binding)
          rescue => e
            raise "Error rendering template '#{template_name}': #{e.message}"
          end

          private

          class RenderContext
            def initialize(data, config)
              @data = data
              @config = config
              data.each { |key, value| instance_variable_set(:"@#{key}", value) }
            end

            def css_classes
              @config.css_classes
            end

            def method_missing(method_name, *args, &block)
              if @data.key?(method_name.to_s)
                @data[method_name.to_s]
              elsif @data.key?(method_name.to_sym)
                @data[method_name.to_sym]
              else
                super
              end
            end

            def respond_to_missing?(method_name, include_private = false)
              @data.key?(method_name.to_s) || @data.key?(method_name.to_sym) || super
            end

            def get_binding
              binding
            end
          end
        end

        class HtmlRenderer
          def initialize(config)
            @config = config
            @template_renderer = TemplateRenderer.new(config)
          end

          def render_ingredient(ingredient_data)
            template_name = @config.legacy_mode? ? "legacy_ingredient" : "ingredient"
            @template_renderer.render(template_name, ingredient_data)
          end

          def render_cookware(cookware_data)
            template_name = @config.legacy_mode? ? "legacy_cookware" : "cookware"
            @template_renderer.render(template_name, cookware_data)
          end

          def render_timer(timer_data)
            @template_renderer.render("timer", timer_data)
          end

          def render_step(step_data)
            template_name = @config.legacy_mode? ? "legacy_step" : "step"
            @template_renderer.render(template_name, step_data)
          end

          def render_list(items, type = "ul", css_class = "")
            list_items = items.map { |item| "<li>#{item}</li>" }.join
            if @config.legacy_mode?
              "<#{type}>#{list_items}</#{type}>"
            else
              class_attr = css_class.empty? ? "" : " class=\"#{css_class}\""
              "<#{type}#{class_attr}>#{list_items}</#{type}>"
            end
          end

          def render_section(heading, content, css_class = "")
            if @config.legacy_mode?
              "<h2>#{heading}</h2>#{content}"
            else
              class_attr = css_class.empty? ? "" : " class=\"#{css_class}\""
              "<section#{class_attr}><h2>#{heading}</h2>#{content}</section>"
            end
          end
        end
      end
    end
  end
end
