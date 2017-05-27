module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end

  def jpost(path, params={}, headers={})
    headers = headers.merge('content-type' => 'application/json') unless params.empty?
    post(path, params.to_json, headers)
  end
end
