module Yakports
  class API < Grape::API

    helpers do
      def yaks
        Yakports.yaks
      end

      def repository
        Yakports.repository
      end
    end

    get 'test' do
      'so far so good'
    end

    get 'airports/:iata_code' do
      yaks.serialize(repository.find_airport_by_code(params[:iata_code]), env)
    end

  end
end
