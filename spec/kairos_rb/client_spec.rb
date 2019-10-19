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

  describe '#recognize' do
    let(:response) do
      {
        'images' => [
          {
            'candidates' => [
              {
                'confidence' => 1,
                'enrollment_timestamp' => '20191018213614',
                'face_id' => 'd7e96f9ce1ec4ddbad8',
                'subject_id' => 'Test User'
              }
            ],
            'transaction' => {
              'confidence' => 1,
              'enrollment_timestamp' => '20191018213614',
              'eyeDistance' => 74,
              'face_id' => 'd7e96f9ce1ec4ddbad8',
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
      VCR.use_cassette 'recognize' do
        expect(client.recognize(image: image, gallery_name: gallery_name)).to eq response
      end
    end
  end

  describe '#detect' do
    let(:response) do
      {
        'images' => [
          {
            'faces' => [
              {
                'attributes' => {
                  'age' => 25,
                  'asian' => 0.00927,
                  'black' => 0.00256,
                  'gender' => {
                    'femaleConfidence' => 1,
                    'maleConfidence' => 0,
                    'type' => 'F'
                  },
                  'glasses' => 'None',
                  'hispanic' => 0.71476,
                  'lips' => 'Together',
                  'other' => 0.00158,
                  'white' => 0.27183
                },
                'chinTipX' => 285,
                'chinTipY' => 754,
                'confidence' => 0.99973,
                'eyeDistance' => 214,
                'face_id' => 1,
                'height' => 647,
                'leftEyeCenterX' => 135,
                'leftEyeCenterY' => 385,
                'pitch' => 11,
                'quality' => -0.12558,
                'rightEyeCenterX' => 349,
                'rightEyeCenterY' => 367,
                'roll' => -6,
                'topLeftX' => 28,
                'topLeftY' => 95,
                'width' => 485,
                'yaw' => 17
              }
            ],
            'file' => 'test1.jpg',
            'height' => 1024,
            'status' => 'Complete',
            'width' => 680
          }
        ]
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'detect' do
        expect(client.detect(image: image)).to eq response
      end
    end
  end

  describe '#all_galeries' do
    let(:response) do
      {
        'gallery_ids' => ['test_gallery'],
        'status' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'all_galeries' do
        expect(client.all_galeries).to eq response
      end
    end
  end

  describe '#gallery_details' do
    let(:response) do
      {
        'status' => 'Complete',
        'subject_ids' => ['Test User']
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'gallery_details' do
        expect(client.gallery_details(gallery_name: gallery_name)).to eq response
      end
    end
  end

  describe '#gallery_subject' do
    let(:response) do
      {
        'face_ids' => [
          {
            'enrollment_timestamp' => '20191018221646',
            'face_id' => '189b6f66e1fb4925973'
          }
        ],
        'status' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'gallery_subject' do
        expect(client.gallery_subject(gallery_name: gallery_name, subject_id: subject_id)).to eq response
      end
    end
  end
end
