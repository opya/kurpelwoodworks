require_relative '../../spec_helper'

describe NoteRepository do
  let(:args) { { id: 1, name: 'test name', description: 'test decription'} }
  let(:model) { Minitest::Mock.new }

  let(:repository) {
    NoteRepository.new(
      note_model:  model
    )
  }

  it "expect to find return NoteEntity" do
    model.expect :model, model
    model.expect :find, args do |id: 1| true end

    assert_equal NoteEntity, repository.find(id: 1).class
    assert model.verify
  end

  it "expect to save and return NoteEntity" do
    model.expect :model, model
    model.expect :new, model do |name: 1, description: 1| true end
    model.expect :save, args

    assert_equal NoteEntity, repository.create!(**args.except(:id)).class
    assert model.verify
  end

  it "expect to save and return NoteEntity" do
    model.expect :model, model
    model.expect :find, args do |id: 1| true end
    model.expect :update, args, [args]

    assert_equal NoteEntity, repository.update!(id: 1, input: args).class
    assert model.verify
  end
end
