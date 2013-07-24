require 'pathname'

class ActiveRecord::FixtureBuilder::Configuration

  attr_writer :root, :fixtures_path, :builders_path

  attr_accessor :excluded_tables

  def initialize
    @excluded_tables = %w{schema_migrations}
  end

  def root
    Pathname @root || case
    when defined? Bundler
      Bundler.root
    when defined? Rails
      Rails.root
    else
      Dir.pwd
    end
  end

  def fixtures_path
    Pathname(@fixtures_path || root.join('spec/fixtures'))
  end

  def builders_path
    Pathname(@builders_path || root.join('spec/fixture_builders'))
  end

  def connection
    @connection || ::ActiveRecord::Base.connection
  end

  def inspect
    super.split(/ |>/).first+'>'
  end

end
