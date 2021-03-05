require 'spec_helper'

RSpec.describe Kurpelwoodworks::Repositories::NoteRepository do
  let(:input) {{ name: 'test name', description: 'long test description' }}
  let(:note) { subject.create!(input) }

  context "#find_by_id" do
    it "successfully" do
      expect(subject.find_by_id(note.id).name).to eq note.name
      expect(subject.find_by_id(note.id)).to be_a(Kurpelwoodworks::Entities::NoteEntity)
    end

    it "nil when record missing" do
      expect(subject.find_by_id(id: nil)).to be_falsy
    end
  end

  context "#create!" do
    let(:result) { subject.create!(input) }

    it "successfully" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq(input[:name])
    end
  end

  context "#update!" do
    let(:update_input) {{ id: note.id, name: 'test name changed', description: 'long test description' }}
    let(:result) {
      subject.update!(update_input)
    }

    it "white existing note" do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq('test name changed')
    end

    it "white missing note" do
      wrong_input = { id: 0, name: 'test name changed', description: 'long test description' }
      result = subject.update!(wrong_input)
      expect(result).to be_falsy
    end
  end

  context "#paginate" do
    it do
      subject.create!(input)
      subject.create!(input)
      subject.create!(input)
      subject.create!(input)

      expect(subject.count).to eq(4)
      expect(subject.paginate(0, 3).count).to eq(3)
    end
  end

  context "#count" do
    it do
      subject.create!(input)
      expect(subject.count).to eq(1)
    end
  end
end
