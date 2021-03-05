require 'spec_helper'

RSpec.describe "Notes route test" do

  describe "notes" do
    describe "list notes" do
      context "valid" do
        it "list notest and paginator" do
          get "/notes"

          r = JSON.parse(last_response.body)

          expect(last_response.status).to be 200
          expect(r.has_key? "notes").to be true
          expect(r.has_key? "paginator").to be true
        end

        it "with page" do
          get "/notes?&page=1"

          r = JSON.parse(last_response.body)

          expect(last_response.status).to be 200
          expect(r.has_key? "notes").to be true
          expect(r.has_key? "paginator").to be true
        end
      end

      context "invalid" do
        it "with garbage page" do
          get "/notes?&page=test"

          r = JSON.parse(last_response.body)

          expect(last_response.status).to be 400
          expect(r.has_key? "notes").to be false
          expect(r.has_key? "paginator").to be false
          expect(r.has_key? "errors").to be true
        end

        it "with a larger offset than the number of notes" do
          get "/notes?&page=100"

          r = JSON.parse(last_response.body)

          expect(last_response.status).to be 400
          expect(r.has_key? "notes").to be false
          expect(r.has_key? "paginator").to be false
          expect(r.has_key? "errors").to be true
        end
      end
    end

    describe "create note" do
      context "when valid" do
        it "create resource and return 200" do
          post "/notes", name: 'long test name', description: 'long test description'

          r = JSON.parse(last_response.body)

          expect(last_response.status).to eq(200)
          expect(r.has_key? "note").to be true
          expect(r["note"]["name"]).to eq "long test name"
          expect(r.has_key? "errors").to be false
        end
      end

      context "when invalid" do
        it "fail to create resource and return 400" do
          post "/notes"

          r = JSON.parse(last_response.body)

          expect(last_response.status).to eq(400)
          expect(r.has_key? "note").to be false
          expect(r.has_key? "errors").to be true
          expect(r["errors"].count).to be 2
        end
      end

    end
  end

  describe "update note" do
    let(:repo) { Kurpelwoodworks::Repositories::NoteRepository.new }
    let(:note) { repo.create!(name: "test name", description: "test description") }

    context "when valid" do
      it "create resource and return 200" do
        note = Kurpelwoodworks::Repositories::NoteRepository.new
        note = note.create!(name: "test name", description: "test description")

        post "/notes/#{note.id}", name: 'long test name change', description: 'long test description change'

        r = JSON.parse(last_response.body)

        expect(last_response.status).to eq(200)
        expect(r.has_key? "note").to be true
        expect(r.has_key? "errors").to be false
        expect(r["note"]["name"]).to eq('long test name change')
      end
    end

    context "when invalid" do
      it "failed to update with wrong id" do
        post "/notes/1", name: 'long test name change', description: 'long test description change'

        r = JSON.parse(last_response.body)

        expect(last_response.status).to eq(400)
        expect(r.has_key? "note").to be false
        expect(r.has_key? "errors").to be true
      end

      it "failed to update with wrong " do
        post "/notes/#{note.id}", description: 'long test description change'

        r = JSON.parse(last_response.body)

        expect(last_response.status).to eq(400)
        expect(r.has_key? "note").to be false
        expect(r.has_key? "errors").to be true
      end
    end

    describe "show note" do
      it "valid" do
        get "/notes/#{note.id}"

        r = JSON.parse(last_response.body)

        expect(last_response.status).to eq(200)
        expect(r.has_key? "note").to be true
        expect(r.has_key? "errors").to be false
      end

      it "invalid" do
        get "/notes/1"

        r = JSON.parse(last_response.body)

        expect(last_response.status).to eq(400)
        expect(r.has_key? "note").to be false
        expect(r.has_key? "errors").to be true
      end
    end
  end
end
