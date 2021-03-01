Sequel.migration do
  up do
    create_table(:notes_tags) do
      foreign_key :note_id, :notes, on_delete: :cascade
      foreign_key :tag_id, :tags, on_delete: :cascade
      primary_key [:note_id, :tag_id]
      index       [:note_id, :tag_id]
    end
  end

  down do
    drop_join_table(note_id: :notes, tag_id: :tags)
  end
end
