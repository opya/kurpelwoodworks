require 'spec_helper'

RSpec.describe Kurpelwoodworks::Actions::Notes::UpdateNoteAction do
  let(:input) {{ id: 1, name: 'long test name', description: 'long test description' }}
  let(:note_repo) { double("NoteRepository") }
  let(:note) {
    Kurpelwoodworks::Entities::NoteEntity.new(
      id: 1,
      name: "test name",
      description: "test description"
    )
  }

  before do
    allow(note_repo).to receive(:update!) { note }
  end

  subject { described_class.new(repository: note_repo) }

  context "#perform" do
    it "fail with invalid params" do
      expect(subject.perform({})).to be_a(Dry::Monads::Failure)
      expect(subject.perform({}).failure).to be_truthy
      expect(subject.perform({}).failure[:errors]).to be_truthy
    end

    it "update new action" do
      expect(subject.perform(input)).to be_a(Dry::Monads::Success)
      expect(subject.perform(input).value!).to be_truthy
    end

    it "update with invalid note" do
      wrong_input = { id: 2, name: 'long test name', description: 'long test description' }
      expect(note_repo).to receive(:update!) { nil }

      s = subject.perform(wrong_input)

      expect(s).to be_a(Dry::Monads::Failure)
      expect(s.failure).to be_truthy
    end
  end
end
