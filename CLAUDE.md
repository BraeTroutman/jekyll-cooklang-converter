# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Setup**: `bin/setup` - Install dependencies after checkout
- **Console**: `bin/console` - Interactive prompt for experimentation
- **Install locally**: `bundle exec rake install` - Install gem to local machine
- **Tests**: `bundle exec rake spec` - Run RSpec tests
- **Linting**: `bundle exec rake standard` - Run StandardRB linter
- **Integration tests**: `bundle exec rake clash` - Run clash integration tests
- **All checks**: `bundle exec rake` - Runs standard, spec, and clash (default task)
- **Release**: `bundle exec rake release` - Create git tag and push to RubyGems

## Architecture

This is a Jekyll plugin that converts Cooklang recipe files (.cook) to HTML. The plugin structure follows Jekyll's converter pattern:

### Core Components

**Main Converter** (`lib/jekyll/converters/cooklang.rb:106-149`):
- `CooklangConverter` class inherits from `Jekyll::Converter`
- Matches `.cook` file extensions and outputs `.html`
- Uses `cooklang_rb` gem to parse recipe files
- Converts parsed data to structured HTML with ingredients, cookware, and steps sections

**HTML Generation Classes** (`lib/jekyll/converters/cooklang.rb:3-105`):
- `Ingredient` - Handles quantity/unit/name formatting with rational number support
- `Timer` - Formats timing instructions
- `CookWare` - Formats cookware requirements  
- `Step` - Converts recipe steps to paragraph HTML
- `OrderedList`/`UnorderedList` - Generate HTML lists for steps and ingredients
- All classes inherit from `ToHTML` base class with `to_html` and `to_list_item` methods

### Dependencies

- **Jekyll** (~> 4.3.4) - Static site generator framework
- **cooklang_rb** (~> 0.2.0) - Cooklang recipe parsing
- **htmlbeautifier** (~> 1.4.3) - HTML formatting
- **rspec** - Testing framework
- **clash** - Integration testing for Jekyll sites
- **standard** - Ruby linting

### Testing Strategy

- **Unit tests**: RSpec tests in `spec/` directory test converter functionality
- **Integration tests**: Clash framework tests actual Jekyll site generation in `clash/test-site/`
- Test site includes `.cook` recipe files and expected HTML output for comparison

### File Structure

- Main gem entry point: `lib/jekyll-cooklang-converter.rb`
- Converter implementation: `lib/jekyll/converters/cooklang.rb` 
- Version: `lib/jekyll-cooklang-converter/version.rb`
- Integration test site: `clash/test-site/` with sample recipes and expected output
