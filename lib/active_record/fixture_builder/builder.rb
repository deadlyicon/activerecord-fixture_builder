class ActiveRecord::FixtureBuilder::Builder

  def initialize fixture_builder, path
    @fixture_builder, @path = fixture_builder, path
  end
  attr_reader :path

  def build!
    load @path
  end

  def inspect
    path = @path.relative_path_from(@fixture_builder.config.fixtures_path)
    %[#<#{self.class} #{path.to_s}>]
  end

end
