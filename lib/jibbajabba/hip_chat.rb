module HipChat
  URL = 'https://api.hipchat.com/v2/'

  class << self

    attr_accessor :api_key

    def configure
      yield self if block_given?
    end

    def credentials
      {'Authorization' => 'Bearer ' + api_key}
    end
  end
end
