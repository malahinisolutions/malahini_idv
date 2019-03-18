class CretateLocationsDb < ActiveRecord::Migration
  def self.up
    drop_table :cities
    drop_table :countries
    drop_table :states

    sql = File.open("world.sql").read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)

    sql.split(';').each do |sql_statement|
      execute(sql_statement)
    end
  end
  
  def self.down
    
  end

end