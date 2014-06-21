require 'pathname'
require 'csv'
require 'json'

require 'yaks'
require 'grape'

module Yakports
  ROOT = Pathname(__FILE__).dirname.parent

  DATA_FORMATS = {
    :airports       => [
      :id           , :name       , :city     , :country   ,
      :iata_code    , :icao_code  , :latitude , :longitude ,
      :elevation_ft , :utc_offset , :dst_type
    ],
    :countries      => [:name, :_, :iso3166_1_alpha_2, ],
    :routes         => [],
    :airlines       => [],
    :airports_dafif => []
  }

  def self.yaks
    @yaks ||= Yaks.new do
      namespace Yakports

      after do |result|
        JSON.pretty_generate result
      end
    end
  end

  def self.repository
    @repo = Repository.new
  end

  class Repository

    def find_airport_by_code(iata_code)
      airports.find{|x| x.iata_code == iata_code }
    end

    def airports
      @airports ||= read_csv('airports.dat').map {|record| Yakports::Airport.new(*record) }
    end

    def read_csv(file)
      CSV.read(ROOT.join('data', file), encoding: "ISO8859-1")
    end

  end

  class Airport < Struct.new(*DATA_FORMATS[:airports])
  end

  class AirportMapper < Yaks::Mapper
    attributes *DATA_FORMATS[:airports]
  end
end

require 'yakports/api'
