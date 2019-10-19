# frozen_string_literal: true

RSpec.describe KairosRB::Client do
  let(:app_id)       { 'test_app_id' }
  let(:app_key)      { 'test_app_key' }
  let(:image)        { 'test_image' }
  let(:subject_id)   { 'Test User' }
  let(:gallery_name) { 'test_gallery' }
  let(:media)        { 'https://media.kairos.com/test.flv' }
  let(:media_id)     { 'adb2d1d66b9adddb06b81889' }
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

  describe '#remove_subject_from_gallery' do
    let(:response) do
      {
        'message' => 'subject id Test User has been successfully removed',
        'status' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'remove_subject_from_gallery' do
        expect(client.remove_subject_from_gallery(gallery_name: gallery_name, subject_id: subject_id)).to eq response
      end
    end
  end

  describe '#remove_gallery' do
    let(:response) do
      {
        'message' => 'gallery test_gallery was removed',
        'status' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'remove_gallery' do
        expect(client.remove_gallery(gallery_name: gallery_name)).to eq response
      end
    end
  end

  describe '#add_media' do
    let(:response) do
      {
        'frames' => [{
          'people' => [{
            'appearance' => {
              'glasses' => 'No'
            },
            'demographics' => {
              'age_group' => 'Adult',
              'gender' => 'Male'
            },
            'distance' => 126.03570556641,
            'emotions' => {
              'anger' => 0,
              'disgust' => 30,
              'fear' => 0,
              'joy' => 43.484,
              'sadness' => 0,
              'surprise' => 0
            },
            'face' => {
              'height' => 428,
              'width' => 378,
              'x' => 180,
              'y' => 52
            },
            'person_id' => 0,
            'pose' => {
              'pitch' => 29.316568356472,
              'roll' => 1.9071428812672,
              'yaw' => -15.206240031162
            },
            'tracking' => {
              'attention' => 1,
              'blinking' => 'Yes',
              'dwell' => 5,
              'glances' => 2
            }
          }],
          'time' => 12_178
        }],
        'id' => 'ca7f791749e94609b181fa41',
        'length' => 12,
        'media_info' => {
          'file' => 'ca7f791749e94609b181fa41.flv',
          'height' => 480,
          'length' => 12,
          'mime_type' => 'video/x-flv',
          'type' => 'video',
          'width' => 640
        },
        'status_code' => 4,
        'status_message' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'add_media' do
        expect(client.add_media(media: media)).to eq response
      end
    end
  end

  describe '#get_media' do
    let(:response) do
      {
        'frames' => [{
          'people' => [{
            'appearance' => {
              'glasses' => 'No'
            },
            'demographics' => {
              'age_group' => 'Adult',
              'gender' => 'Male'
            },
            'distance' => 126.03570556641,
            'emotions' => {
              'anger' => 0,
              'disgust' => 30,
              'fear' => 0,
              'joy' => 43.484,
              'sadness' => 0,
              'surprise' => 0
            },
            'face' => {
              'height' => 428,
              'width' => 378,
              'x' => 180,
              'y' => 52
            },
            'person_id' => 0,
            'pose' => {
              'pitch' => 29.316568356472,
              'roll' => 1.9071428812672,
              'yaw' => -15.206240031162
            },
            'tracking' => {
              'attention' => 1,
              'blinking' => 'Yes',
              'dwell' => 5,
              'glances' => 2
            }
          }],
          'time' => 12_178
        }],
        'id' => 'ca7f791749e94609b181fa41',
        'length' => 12,
        'media_info' => {
          'file' => 'ca7f791749e94609b181fa41.flv',
          'height' => 480,
          'length' => 12,
          'mime_type' => 'video/x-flv',
          'type' => 'video',
          'width' => 640
        },
        'status_code' => 4,
        'status_message' => 'Complete'
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'get_media' do
        expect(client.get_media(media_id: media_id)).to eq response
      end
    end
  end

  describe '#media_analytics' do
    let(:response) do
      {
        'id' => 'adb2d1d66b9adddb06b81889',
        'impressions' => [{
          'appearance' => {
            'glasses' => 'No'
          },
          'average_emotion' => {
            'anger' => 0,
            'disgust' => 35.614,
            'fear' => 0.685,
            'joy' => 47.86,
            'sadness' => 17.524,
            'surprise' => 0
          },
          'demographics' => {
            'age_group' => 'Young Adult',
            'gender' => 'Male'
          },
          'emotion_score' => {
            'negative' => 14.456,
            'neutral' => 34.404,
            'positive' => 48.86
          },
          'person_id' => 0,
          'tracking' => {
            'attention' => 100,
            'dwell' => 5,
            'glances' => 2
          }
        }],
        'media_info' => {
          'filename' => 'adb2d1d66b9adddb06b81889.flv',
          'length' => 12,
          'mime_type' => 'video/x-flv',
          'type' => 'video'
        }
      }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'media_analytics' do
        expect(client.media_analytics(media_id: media_id)).to eq response
      end
    end
  end

  describe '#remove_media' do
    let(:response) do
      { 'id' => 'adb2d1d66b9adddb06b81889', 'status_code' => '5', 'status_message' => 'Deleted' }
    end

    it 'returns parsed json response' do
      VCR.use_cassette 'remove_media' do
        expect(client.remove_media(media_id: media_id)).to eq response
      end
    end
  end
end
