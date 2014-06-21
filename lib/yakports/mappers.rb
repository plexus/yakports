module Yakports
  class BaseMapper < Yaks::Mapper
    def self.inherited(base)
      super
      alt_name = Yaks::Util.underscore(base.name.sub(/.*::/,'').sub('Mapper',''))
      base.send(:alias_method, alt_name, :object)
    end

    def filter(attrs)
      attrs - env.fetch('api.exclude', [])
    end
  end

  class CountryMapper < BaseMapper
    attributes :id, :name, :iso3166_1_alpha_2, :dst_type

    link 'airports', '/countries/{id}/airports'
    link 'airlines', '/countries/{id}/airlines'

    def id
      country.iso3166_1_alpha_2
    end
  end

  class AirportMapper < BaseMapper
    link :self, '/airports/{id}'

    attributes *DATA_FORMATS[:airports]

    def country_code
      airport.country.iso3166_1_alpha_2
    end
  end

  class AirlineMapper < BaseMapper
    link :self, '/airlines/{iata_code}'

    attributes :id, :name, :alt_name, :iata_code, :icao_code, :call_sign, :active

    has_one :country

    def country
      Repository.find_country_by_name(airline.country_name)
    end

    def active
      airline.active == "Y"
    end
  end
end
