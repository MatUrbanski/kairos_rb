# frozen_string_literal: true

RSpec.describe KairosRB::Client do
  let(:app_id)       { 'test_app_id' }
  let(:app_key)      { 'test_app_key' }
  let(:image)        { 'test_image' }
  let(:subject_id)   { 'Test User' }
  let(:gallery_name) { 'test_gallery' }
  let(:client)       { described_class.new(app_id: app_id, app_key: app_key) }

  describe '#enroll' do
    let(:response) do
      {

        'face_id' => '189b6f66e1fb4925973',
        'images' => [
          {
            'attributes' => {
              'age' => 33,
              'asian' => 0.00151,
              'black' => 0.00024,
              'gender' => {
                'femaleConfidence' => 0,
                'maleConfidence' => 1,
                'type' => 'M'
              },
              'glasses' => 'None',
              'hispanic' => 0.01141,
              'lips' => 'Together',
              'other' => 0.00057,
              'white' => 0.98627
            }, 'transaction' => {
              'confidence' => 0.99919,
              'eyeDistance' => 74,
              'face_id' => '189b6f66e1fb4925973',
              'gallery_name' => 'test_gallery',
              'height' => 224,
              'image_id' => 1,
              'pitch' => 10,
              'quality' => 0.0776,
              'roll' => -4,
              'status' => 'success',
              'subject_id' => 'Test User',
              'timestamp' => '20191018221646',
              'topLeftX' => 147,
              'topLeftY' => 86,
              'version' => 2,
              'width' => 175,
              'yaw' => 15
            }
          }
        ]
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'enroll' do
        expect(client.enroll(image: image, subject_id: subject_id, gallery_name: gallery_name)).to eq response
      end
    end
  end

  describe '#verify' do
    let(:response) do
      {
        'images' => [
          {
            'transaction' => {
              'confidence' => 1,
              'enrollment_timestamp' => '20191018221646',
              'eyeDistance' => 74,
              'face_id' => '189b6f66e1fb4925973',
              'gallery_name' => 'test_gallery',
              'height' => 224,
              'pitch' => 10,
              'quality' => 0.0776,
              'roll' => -4,
              'status' => 'success',
              'subject_id' => 'Test User',
              'topLeftX' => 147,
              'topLeftY' => 86,
              'width' => 175,
              'yaw' => 15
            }
          }
        ]
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'verify' do
        expect(client.verify(image: image, subject_id: subject_id, gallery_name: gallery_name)).to eq response
      end
    end
  end
end
