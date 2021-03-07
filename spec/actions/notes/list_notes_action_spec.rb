require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::ListNotesAction do
  let(:note_repo) { double("NoteRepository") }
  let(:note) {
    Kurpelwoodworks::Entities::NoteEntity.new(
      id: 1,
      name: "test name",
      description: "test description",
      created_at: Time.now,
      updated_at: Time.now
    )
  }

  subject { described_class.new(repository: note_repo) }

  context "#perform" do
    it "valid" do
      allow(note_repo).to receive(:count) { 1 }
      allow(note_repo).to receive(:paginate) { [note] }
      result = subject.perform(1)
      expect(result).to be_a(Dry::Monads::Success)
      expect(result.value![:notes].count).to eq 1
    end

    it "invalid with non int" do
      allow(note_repo).to receive(:count) { 1 }
      allow(note_repo).to receive(:paginate) { [note] }
      result = subject.perform(:bad_page)
      expect(result).to be_a(Dry::Monads::Failure)
      expect(result.failure).to be_truthy
    end

    it "invalid number" do
      allow(note_repo).to receive(:count) { 1 }
      allow(note_repo).to receive(:paginate) { [note] }
      result = subject.perform(0)
      expect(result).to be_a(Dry::Monads::Failure)
      expect(result.failure).to be_truthy
    end
  end
end
