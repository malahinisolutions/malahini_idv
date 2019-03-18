class CreateRegions < ActiveRecord::Migration
  def self.up
    
    # sql = File.open("worlddb.sql").read
    
    sql = File.open("mysql_cities_demo.sql").read

    sql.split(';').each do |sql_statement|
      execute(sql_statement)
    end

  end

  def self.down
    # drop_table(:countries)
    # drop_table(:cities)
    # drop_table(:states)
  end
end
