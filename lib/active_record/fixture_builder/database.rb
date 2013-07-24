class ActiveRecord::FixtureBuilder::Database

  def initialize(config)
    @config = config
  end

  def connection
    @config.connection
  end

  def truncate table_name
    connection.delete "DELETE FROM #{connection.quote_table_name(table_name)}"
  end

  def table_names
    connection.tables - @config.excluded_tables
  end

  def truncate_all_tables!
    table_names.each{|table_name| truncate table_name }
  end

  def reset_pk_sequence table_name
    connection.reset_pk_sequence! table_name
  end

  def insert table_name, fixture_name, record
    return if record.blank?

    columns = Hash[connection.columns(table_name).map { |c| [c.name, c] }]
    table_name = connection.quote_table_name(table_name)

    column_names = []
    values = []

    record.each do |column_name, value|
      column_names << connection.quote_column_name(column_name)
      values << connection.quote(value, columns[column_name])
    end

    connection.insert "INSERT INTO #{table_name} (#{column_names.join(', ')}) VALUES (#{values.join(', ')})", "Inserting Fixture #{fixture_name.inspect}"
  end

  def select_all table_name
    connection.select_all("SELECT * FROM #{connection.quote_table_name(table_name)}")
  end

end
