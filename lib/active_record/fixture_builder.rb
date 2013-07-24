require 'active_record/fixture_builder/version'
require 'active_support/core_ext/module/delegation'

module ActiveRecord
  class FixtureBuilder
    autoload :Configuration, 'active_record/fixture_builder/configuration'
    autoload :Database,      'active_record/fixture_builder/database'
    autoload :Fixture,       'active_record/fixture_builder/fixture'
    autoload :Builder,       'active_record/fixture_builder/builder'
  end
end

class ActiveRecord::FixtureBuilder

  def initialize(&block)
    configure(&block) if block_given?
  end

  def config
    @config ||= Configuration.new
  end

  def configure
    yield config
    self
  end

  def database
    config.freeze
    @database ||= Database.new(config)
  end

  def fixtures
    config.freeze
    @fixtures ||= Dir[config.fixtures_path+'*.yml'].map do |path|
      Fixture.new self, Pathname(path)
    end
  end

  def builders
    config.freeze
    @builders ||= Dir[config.builders_path+'*.rb'].map do |path|
      Builder.new self, Pathname(path)
    end
  end

  def load_fixtures!
    fixtures.each(&:load!)
  end

  def build_fixtures!
    database.truncate_all_tables!
    builders.each(&:build!)
  end

  def write_fixtures!
    database.table_names.each do |table_name|
      config.fixtures_path.join("#{table_name}.yml").open('w') do |file|
        records = database.select_all(table_name)

        fixture_data = {}
        records.each_with_index do |record, index|
          fixture_data["#{table_name}_#{index.to_s.rjust(3,'0')}"] = record
        end

        file.write fixture_data.to_yaml
      end
    end
  end

  def inspect
    super.split(/ |>/).first+'>'
  end

  PUBLIC_INSTANCE_METHODS = public_instance_methods - superclass.public_instance_methods

  class << self
    def instance
      @instance ||= new
    end

    delegate *PUBLIC_INSTANCE_METHODS, to: :instance
  end

end
