Sequel.migration do
  up do
    create_table :records do
      primary_key :id
      String :name, null: false
      Text :description, null: false
    end
  end

  down do
    drop_table(:records)
  end
end
