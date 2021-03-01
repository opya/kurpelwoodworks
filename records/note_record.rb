require 'records/tag_record'

module Kurpelwoodworks
  class NoteRecord < Sequel::Model(:notes)
    many_to_many :tags, left_key: :note_id, right_key: :tag_id, join_table: :notes_tags, class: TagRecord
  end
end
