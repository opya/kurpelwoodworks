require 'spec_helper'

RSpec.describe Kurpelwoodworks::Repositories::NoteRepository do
  let(:input) {{ name: 'test name', description: 'long test description' }}
  let(:note) { subject.create!(input: input) }

  context "#find" do
    it "by id:" do
      expect(subject.find(id: note.id).name).to eq note.name
      expect(subject.find(id: note.id)).to be_a(Kurpelwoodworks::Entities::NoteEntity)
    end

    it "nil when record missing" do
      expect(subject.find(id: nil)).to be_falsy
    end
  end

  context "#create!" do
    let(:result) { subject.create!(input: input) }

    it do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq(input[:name])
    end
  end

  context "#update!" do
    let(:update_input) {{ name: 'test name changed', description: 'long test description' }}
    let(:result) {
      subject.update!(
        id: note.id,
        input: update_input
      )
    }

    it do
      expect(result).to be_truthy
      expect(result).to be_a(Kurpelwoodworks::Entities::NoteEntity)
      expect(result.name).to eq('test name changed')
    end
  end

  context "#paginate" do
    it do
      subject.create!(input: input)
      subject.create!(input: input)
      subject.create!(input: input)
      subject.create!(input: input)

      expect(subject.count).to eq(4)
      expect(subject.paginate(offset: 0, limit: 3).count).to eq(3)
    end
  end

  context "#count" do
    it do
      subject.create!(input: input)
      expect(subject.count).to eq(1)
    end
  end
end
