module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end

  # automates the passing of payload bodies as json
  ['post', 'put'].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params={}, headers={}|
      headers = headers.merge('content-type' => 'application/json') unless params.empty?
      self.send(http_method_name, path, params.to_json, headers)
    end
  end
end

RSpec.shared_examples "resource index" do |model|
    let!(:resources) { (1..5).map { FactoryGirl.create(model) } }
    let(:payload) { parsed_body }

    it "returns all #{model} instances" do
      get send("#{model}s_path"), {"Accept"=>"application/json"}
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")

      expect(payload.count).to eq(resources.count)
      response_check
      response_check if respond_to?(:response_check)
    end

end