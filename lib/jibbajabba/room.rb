module HipChat
  class Room
    class << self

      # undef_method :to_s, :inspect

      attr_writer :query

      def query
        @query ||= url
      end

      def url
        URL + 'room?'
      end

      def to_hash
        raise 'No API key assigned.' unless HipChat.api_key
        response = open(query, HipChat.credentials){|f| f.read }
        JSON.parse(response)
      end

      def class
        'HipChat::Room'
      end

      def method_missing(method, *args, &block)
        to_hash.send(method, *args, &block)
      end

      # API METHODS

      def all
        @query = url
        self
      end
      alias_method :list, :all

      def offset(number)
        @query += "start-index=#{number.to_i}&"
        self
      end
      alias_method :start_index, :offset

      def limit(number)
        @query += "max-results=#{number.to_i}&"
        self
      end
      alias_method :max_results, :limit

      def create(name:, **kwargs)
        params = {name: CGI.escape(name)}.merge(kwargs)
        response = HTTParty.post(url[0..-2], body: params.to_json, headers:
          {'Content-Type' => 'application/json'}.merge(HipChat.credentials)
        )
        eval(response.to_s)
      end
    end
  end
end
