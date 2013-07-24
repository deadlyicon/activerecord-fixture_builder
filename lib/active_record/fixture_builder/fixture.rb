class ActiveRecord::FixtureBuilder::Fixture

  def initialize fixture_builder, path
    @fixture_builder, @path = fixture_builder, path
  end
  attr_reader :path

  def table_name
    @table_name ||= File.basename(@path, '.yml')
  end

  def records_from_file
    Array YAML.load_file @path
  end

  # def records_from_database
  #   @fixture_builder.select_all(table_name)
  # end

  # def write!
  #   path.open('w') do |file|
  #     file.write records_from_database.to_yaml
  #   end
  # end

  def load!
    @fixture_builder.database.truncate table_name
    records_from_file.each do |fixture_name, record|
      @fixture_builder.database.insert(table_name, fixture_name, record)
    end
    @fixture_builder.database.reset_pk_sequence table_name
  end

  def inspect
    path = @path.relative_path_from(@fixture_builder.config.fixtures_path)
    %[#<#{self.class} #{path.to_s}>]
  end

end
