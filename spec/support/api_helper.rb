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
    response_check if respond_to?(:response_check)
  end
end

RSpec.shared_examples "show resource" do |model|
  let(:resource) { FactoryGirl.create(model) }
  let(:payload) { parsed_body }
  let(:bad_id) { 1234567890 }

  it "returns #{model} when using correct ID" do
    get send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")
    response_check if respond_to?(:response_check)
  end

  it "returns not found when using incorrect ID" do
    get send("#{model}_path", bad_id)
    expect(response).to have_http_status(:not_found)
    expect(response.content_type).to eq("application/json")

    
    expect(payload).to have_key("errors")
    expect(payload["errors"]).to have_key("full_messages")
    expect(payload["errors"]["full_messages"][0]).to include("cannot", "#{bad_id}")
  end
end

RSpec.shared_examples "create resource" do |model|
  let(:resource_state) { FactoryGirl.attributes_for(model) }
  let(:payload) { parsed_body }

  it "can create with provided name" do
    jpost send("#{model}s_path"), resource_state
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq("application/json")

    expect(payload).to have_key("id")
    expect(payload).to have_key("name")
    expect(payload["name"]).to eq(resource_state[:name])
    id = payload["id"]
    # verify we can locate the created instance in DB
    expect(model.to_s.capitalize.constantize.find(id).name).to eq(resource_state[:name])
  end
end

RSpec.shared_examples "existing resource" do |model|
  let(:resource) { FactoryGirl.create(model) }
  let(:resource_path) { "#{model}_path" }
  let(:new_name) { "testing" }

  it "can update name" do
    pp "resource name: #{resource.class}"
    expect(resource.name).to_not eq(new_name)
    # change to the new name
    jput send(resource_path, resource.id), {:name => new_name}
    expect(response).to have_http_status(:no_content)
    #verify we can locate the created instance in DB
    expect(resource.class.find(resource.id).name).to eq(new_name)
  end

  it "can be deleted" do
    head send(resource_path, resource.id)
    expect(response).to have_http_status(:ok)

    delete send(resource_path, resource.id)
    expect(response).to have_http_status(:no_content)

    head send(resource_path, resource.id)
    expect(response).to have_http_status(:not_found)
  end
end