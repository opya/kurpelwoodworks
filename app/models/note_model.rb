require 'models/tag_model'

class NoteModel < Sequel::Model(:notes)
  many_to_many :tags, left_key: :tag_id, right_key: :note_id, join_table: :notes_tags, class: 'TagModel'
end
