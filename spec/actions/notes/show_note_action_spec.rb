require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::ShowNoteAction do
  let(:note_repo) { double("NoteRepository") }
  let(:note) {
    Kurpelwoodworks::Entities::NoteEntity.new(
      id: 1,
      name: "test name",
      description: "test description"
    )
  }

  subject { described_class.new(repository: note_repo) }

  context "#perform" do
    it "with existing record" do
      allow(note_repo).to receive(:find) { note }
      result = subject.perform(note.id)
      expect(result).to be_truthy
      expect(result.errors).to be_empty
      expect(result.note[:id]).to eq note.id
    end

    it "null id" do
      expect(note_repo).to receive(:find) { nil }
      result = subject.perform(nil)
      expect(result).to be_truthy
      expect(result.errors).not_to be_empty
      expect(result.note).to be_falsy
    end
  end
end
