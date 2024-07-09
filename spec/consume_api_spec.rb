require 'spec_helper'

RSpec.describe APIEasyBroker do
  let(:api_url) { "https://api.stagingeb.com/v1/properties" }
  let(:token) { 'l7u502p8v46ba3ppgvj5y2aad50lb9' }
  let(:client) { APIEasyBroker.new(api_url, token) }

  describe '#fetch_properties' do
    it 'fetches properties from the API' do
      stub_request(:get, api_url)
        .with(headers: { 'Accept' => 'application/json', 'X-Authorization' => token })
        .to_return(
          status: 200,
          body: { content: [{ title: 'Property 1' }, { title: 'Property 2' }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.fetch_properties
      expect(response['content']).to be_an(Array)
      expect(response['content'].first['title']).to eq('Property 1')
    end
  end

  describe '#print_titles' do
    it 'prints property titles' do
      stub_request(:get, api_url)
        .with(headers: { 'Accept' => 'application/json', 'X-Authorization' => token })
        .to_return(
          status: 200,
          body: { content: [{ title: 'Property 1' }, { title: 'Property 2' }] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { client.print_titles }.to output("Title: Property 1\nTitle: Property 2\n").to_stdout
    end

    it 'handles missing content array' do
      stub_request(:get, api_url)
        .with(headers: { 'Accept' => 'application/json', 'X-Authorization' => token })
        .to_return(
          status: 200,
          body: {}.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { client.print_titles }.to output("Array 'content' not found in JSON reponse\n").to_stdout
    end
  end
end