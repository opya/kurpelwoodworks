Sequel.migration do
  up do
    create_table(:records_tags) do
      foreign_key :record_id, :records, on_delete: :cascade
      foreign_key :tag_id, :tags, on_delete: :cascade
      primary_key [:record_id, :tag_id]
      index       [:record_id, :tag_id]
    end
  end

  down do
    drop_join_table(record_id: :records, tag_id: :tags)
  end
end
