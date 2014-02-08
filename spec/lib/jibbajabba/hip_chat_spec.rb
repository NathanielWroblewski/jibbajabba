require 'spec_helper'

describe HipChat, '::URL' do
  it 'returns the api url' do
    expect(HipChat::URL).to eq 'https://api.hipchat.com/v2/'
  end
end

describe HipChat, '.configure' do
  let(:api_key) { SecureRandom.hex }

  it 'sets the api key when passed a block assigning the key' do
    HipChat.configure{|config| config.api_key = api_key }

    expect(HipChat.api_key).to eq api_key
  end
end

describe HipChat, '.credentials' do
  let(:api_key) { SecureRandom.hex }

  it 'returns the API authorization headers' do
    HipChat.api_key = api_key

    expect(HipChat.credentials).to eq({'Authorization' => "Bearer #{api_key}"})
  end
end
