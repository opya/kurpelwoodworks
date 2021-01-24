Sequel.migration do
  up do
    create_join_table(record_id: :records, tag_id: :tags)
  end

  down do
    drop_join_table(record_id: :records, tag_id: :tags)
  end
end
