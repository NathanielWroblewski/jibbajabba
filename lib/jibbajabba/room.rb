module HipChat
  class Room
    class << self

      undef_method :to_s, :inspect

      attr_writer :query

      def query
        @query ||= url
      end

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
    end
  end
end
