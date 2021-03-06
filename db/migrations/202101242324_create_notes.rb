Sequel.migration do
  up do
    create_table :notes do
      primary_key :id
      String :name, null: false
      Text :description, null: false
      DateTime :created_at 
      DateTime :updated_at 
    end
  end

  down do
    drop_table(:notes)
  end
end
