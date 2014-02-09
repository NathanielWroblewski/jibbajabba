require 'spec_helper'
require 'pry'

describe HipChat::Room do
  before :each do
    HipChat.api_key = nil
    HipChat::Room.stub(:to_hash)
    HipChat::Room.all
  end

  describe '.url' do
    it 'returns the API url appended with "room"' do
      api_url = HipChat::URL + 'room?'

      expect(HipChat::Room.url).to eq api_url
    end
  end

  describe '.query' do
    it 'defaults to the url' do
      expect(HipChat::Room.query).to eq HipChat::Room.url
    end
  end

  describe '.all' do
    it 'queries the API for the list of rooms' do
      HipChat::Room.all

      expect(HipChat::Room.query).to eq HipChat::Room.url
    end
  end

  describe '.offset' do
    it 'sets the start index for the API query' do
      HipChat::Room.offset(5)

      expect(HipChat::Room.query).to eq(HipChat::Room.url + 'start-index=5&')
    end
  end

  describe '.limit' do
    it 'sets the maximum number of results for the API query' do
      HipChat::Room.limit(5)

      expect(HipChat::Room.query).to eq(HipChat::Room.url + 'max-results=5&')
    end
  end

  describe '.class' do
    it 'returns HipChat::Room' do
      expect(HipChat::Room.class).to eq 'HipChat::Room'
    end
  end

  describe '.to_hash' do
    let(:api_key)      { SecureRandom.hex }
    let(:api_response) { JSON.dump({ hello: 'world' }) }

    before :each do
      HipChat::Room.unstub(:to_hash)
      HipChat::Room.stub(:open).and_return(api_response)
      HipChat.api_key = api_key
    end

    it 'kicks the API query' do
      response = HipChat::Room.all.to_hash

      expect(HipChat::Room).to have_received(:open).with(
        'https://api.hipchat.com/v2/room?',
        { 'Authorization' => "Bearer #{api_key}"}
      )
      expect(response).to eq({'hello' => 'world'})
    end

    it 'kicks chained API queries' do
      HipChat::Room.all.limit(5).offset(7).to_hash

      expect(HipChat::Room).to have_received(:open).with(
        'https://api.hipchat.com/v2/room?max-results=5&start-index=7&',
        { 'Authorization' => "Bearer #{api_key}"}
      )
    end

    it 'errors unless an API key is set' do
      HipChat.api_key = nil
      blah = HipChat::Room rescue nil

      expect(
        begin
          HipChat::Room.to_hash
        rescue Exception => e
          e.message
        end
      ).to eq 'No API key assigned.'
    end
  end
end

describe HipChat::Room do
  describe '.create' do
    let(:api_key)      { SecureRandom.hex }
    let(:api_response) {
      { 'id'    => 433241,
        'links' => {
          'self' => 'https://api.hipchat.com/v2/room/433241'
        }
      }
    }

    it 'creates a new room' do
      HipChat.api_key = api_key
      HTTParty.stub(:post).and_return(api_response)

      room = HipChat::Room.create(name: 'Boom Pop')

      expect(HTTParty).to have_received(:post).with(
        'https://api.hipchat.com/v2/room',
        body: {name: 'Boom+Pop'}.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        }
      )
      expect(room.attributes).to eq(api_response)
    end
  end
end

describe HipChat::Room do
  describe '#update_attributes' do
    let(:api_key)      { SecureRandom.hex }
    let(:api_response) {
      { 'id'    => 433241,
        'links' => {
          'self' => 'https://api.hipchat.com/v2/room/433241'
        }
      }
    }

    before :each do
      HipChat.api_key = api_key
      HTTParty.stub(:put)
    end

    it 'updates a room with new attributes' do
      room = HipChat::Room.new(api_response)

      room.update_attributes(name: 'BoomPop', privacy: 'public')

      expect(HTTParty).to have_received(:put).with(
        'https://api.hipchat.com/v2/room/433241',
        body: {name: 'BoomPop', privacy: 'public'}.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        }
      )
    end
  end
end
