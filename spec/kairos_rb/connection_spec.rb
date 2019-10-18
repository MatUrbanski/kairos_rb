# frozen_string_literal: true

RSpec.describe KairosRB::Connection do
  describe '#call' do
    let(:url)     { 'https://api.kairos.com' }
    let(:faraday) { Faraday.new }
    let(:app_id)  { 'test_app_id' }
    let(:app_key) { 'test_app_key' }

    let(:connection) do
      described_class.new(
        app_id: app_id,
        app_key: app_id
      )
    end

    before do
      expect(Faraday)
        .to receive(:new)
        .with(url)
        .and_return(faraday)
    end

    context 'when no errors is raised' do
      let(:galleries_response) do
        Faraday::Response.new(
          body: { 'gallery_ids' => ['test_gallery'], 'status' => 'Complete' }
        )
      end

      before do
        expect(faraday)
          .to receive(:post)
          .with('/gallery/list_all')
          .and_return(galleries_response)
      end

      it 'calls specified endpoint and returns json response' do
        expect(connection.call(url: '/gallery/list_all', method: 'post')).to eq galleries_response.body
      end
    end

    context 'when API returns error' do
      before do
        expect(faraday)
          .to receive(:post)
          .with('/gallery/list_all')
          .and_raise(Faraday::ClientError.new(status: 401))
      end

      it 'raises an error' do
        expect { connection.call(url: '/gallery/list_all', method: 'post') }.to raise_error(Faraday::ClientError)
      end
    end
  end
end
