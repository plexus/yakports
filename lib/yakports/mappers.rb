module Yakports
  class BaseMapper < Yaks::Mapper
    def self.inherited(base)
      super
      alt_name = Yaks::Util.underscore(base.name.sub(/.*::/,'').sub('Mapper',''))
      base.send(:alias_method, alt_name, :object)
    end
  end

  class RootMapper < Yaks::Mapper
    link 'countries', '/countries'
    link 'country', '/countries/{country_code}', expand: false
    link 'airports', '/airports'
    link 'airlines', '/airlines'
    link 'airport', '/airports/{iata_code}', expand: false
  end

  class CountryMapper < BaseMapper
    attributes :id, :name, :iso3166_1_alpha_2, :dst_type

    link :self, '/countries/{id}'
    link 'airports', '/countries/{id}/airports'
    link 'airlines', '/countries/{id}/airlines'

    def id
      country.iso3166_1_alpha_2
    end
  end

  class AirportMapper < BaseMapper
    link :self, '/airports/{id}'
    link 'flightstats', 'http://www.flightstats.com/go/Airport/airportDetails.do?airportCode={iata_code}'
    link 'wikipedia', :wikipedia_link

    attributes *DATA_FORMATS[:airports]

    has_one :country

    def wikipedia_link
      return if airport.iata_code.nil? || airport.iata_code.empty?
      if path = WikipediaAirports.lookup(airport.iata_code)
        "https://en.wikipedia.org" + path
      end
    end

    def country_code
      airport.country.iso3166_1_alpha_2
    end
  end

  class AirlineMapper < BaseMapper
    link :self, '/airlines/{id}'

    attributes :id, :name, :alt_name, :iata_code, :icao_code, :call_sign, :active

    has_one :country

    def country
      Repository.find_country_by_name(airline.country_name)
    end

    def active
      airline.active == "Y"
    end
  end

  class CollectionMapper < Yaks::CollectionMapper
    attributes :count, :offset

    link :previous, :previous_link
    link :next, :next_link

    PAGE_SIZE = 20

    def request
      Rack::Request.new(env)
    end

    def params
      request.params
    end

    def offset
      params.fetch('offset') { 0 }.to_i
    end

    alias full_collection collection

    def collection
      collection = full_collection

      if mapper_stack.any? || collection.count < PAGE_SIZE
        collection
      elsif %w[offset limit].all? &collection.method(:respond_to?)
        collection.offset(offset).limit(PAGE_SIZE)
      else
        collection.drop(offset).take(PAGE_SIZE)
      end
    end

    def count
      full_collection.count
    end

        def previous_link
          if offset > 0
            URITemplate.new("#{env['PATH_INFO']}{?offset}").expand(offset: [offset - PAGE_SIZE, 0].max)
          end
        end

        def next_link
          if offset + PAGE_SIZE < count
            URITemplate.new("#{env['PATH_INFO']}{?offset}").expand(offset: offset + PAGE_SIZE)
          end
        end

  end
end
