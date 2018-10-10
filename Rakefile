#!/usr/bin/env rake

require 'rake/testtask'
require 'rubocop/rake_task'

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

# lint the project
desc 'Run robocop linter'
task lint: [:rubocop]

# run tests
desc 'default resource pack checks'
task default: [:lint, 'test:check']

namespace :test do
  # Specify the directory for the integration tests
  integration_dir = 'test/integration'

  # Specify the terraform plan name
  plan_name = "inspec-digitalocean.plan"

  # The below file allows to inject parameters as profile attributes to inspec
  profile_attributes = "attributes.yml"

  # run inspec check to verify that the profile is properly configured
  task :check do
    dir = File.join(File.dirname(__FILE__))
    sh("bundle exec inspec check #{dir}")
    # run inspec check on the sample profile to ensure all resources are loaded okay
    sh("bundle exec inspec check #{integration_dir}/verify")
  end

  task :init_workspace do
    # Initialize terraform workspace
    cmd = format("cd %s/build/ && terraform init", integration_dir)
    sh(cmd)
  end

  task :plan_integration_tests do
    puts "----> Setup"
    # Create the plan that can be applied
    cmd = format("cd %s/build/ && terraform plan -out %s", integration_dir, plan_name)
    sh(cmd)
  end

  task :setup_integration_tests do
    cmd = format("cd %s/build/ && terraform apply %s", integration_dir, plan_name)
    sh(cmd)
  end

  task :run_integration_tests do
    puts "----> Run"
    cmd = format("inspec exec %s/verify --distinct_exit --attrs %s/%s -t digitalocean://", integration_dir, integration_dir, profile_attributes)
    sh(cmd)
  end

  task :cleanup_integration_tests do
    puts "----> Cleanup"
    cmd = format("cd %s/build/ && terraform destroy -force || true", integration_dir)
    sh(cmd)
  end

  desc 'converts tfstate to attributes'
  task :tfstate do
    require 'json'
    state = JSON.parse(File.read("#{integration_dir}/build/terraform.tfstate"))

    iattributes = {}
    state['modules'][0]['resources'].each { |k, v|
      iattributes[k] = v["primary"]["attributes"]
    }

    # write inspec attributes
    require 'yaml'
    File.open("#{integration_dir}/#{profile_attributes}", "w") { |file| file.write(iattributes.to_yaml) }
  end

  desc "Perform Integration Tests"
  task :integration do
    Rake::Task["test:init_workspace"].execute
    if File.exists?(File.join(integration_dir,"build"))
      Rake::Task["test:cleanup_integration_tests"].execute
    end
    Rake::Task["test:plan_integration_tests"].execute
    Rake::Task["test:setup_integration_tests"].execute
    Rake::Task["test:tfstate"].execute
    Rake::Task["test:run_integration_tests"].execute
    Rake::Task["test:cleanup_integration_tests"].execute
  end
end

# Automatically generate a changelog for this project. Only loaded if
# the necessary gem is installed.
# use `rake changelog to=1.2.0`
begin
  v = ENV['to']
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = v
  end
rescue LoadError
  puts '>>>>> GitHub Changelog Generator not loaded, omitting tasks'
end
