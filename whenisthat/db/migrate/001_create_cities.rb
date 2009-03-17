class CreateCities < Sequel::Migration
  def up
    create_table(:cities) {
      primary_key :id
      column :source_city, :string
      column :destination_city, :string
      column :from_email, :string
    }
  end

  def down
    drop_table(:cities)
  end
end
