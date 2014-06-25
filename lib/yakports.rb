require 'pathname'
require 'csv'
require 'json'

require 'yaks'
require 'grape'

module Yakports
  ROOT = Pathname(__FILE__).dirname.parent

  DATA_FORMATS = {
    :airports       => [
      :id           , :name       , :city     , :country_name   ,
      :iata_code    , :icao_code  , :latitude , :longitude ,
      :elevation_ft , :utc_offset , :dst_type
    ],
    :countries      => [:name, :unkown, :iso3166_1_alpha_2, :dst_type ],
    :routes         => [],
    :airlines       => [
      :id        , :name      , :alt_name     , :iata_code ,
      :icao_code , :call_sign , :country_name , :active
    ],
    :airports_dafif => []
  }

  def self.yaks
    @yaks ||= Yaks.new do
      namespace Yakports

      rel_template 'rels:{dest}'

      after do |result|
        JSON.pretty_generate result
      end
    end
  end

end

require 'yakports/api'
require 'yakports/repository'
require 'yakports/wikipedia_airports'
require 'yakports/models'
require 'yakports/mappers'
