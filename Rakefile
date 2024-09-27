# frozen_string_literal: true

require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"

task default: [:standard, :spec, :clash]

task :clash do |t|
  sh "bundle exec clash clash"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "--format documentation"
end
