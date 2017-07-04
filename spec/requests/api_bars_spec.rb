require 'rails_helper'

RSpec.describe "Bar API", type: :request do
  include_context "db_cleanup_each"

  context "caller requests list of Bars" do
    it_should_behave_like "resource index", :bar do
      let(:response_check) do
        expect(payload.count).to eq(resources.count)
        expect(payload.map {|f| f["name"] }).to eq(resources.map { |f| f[:name] })
      end
    end

  end

  context "a specific Bar exists" do
    it "returns Bar when using correct ID"
    it "returns not found when using incorrect ID"
  end

  context "create a new Bar" do
    it "can create with provided name"
  end

  context "existing Bar" do
    it "can update name"
  end

end
