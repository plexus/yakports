module Yakports
  module Repository
    extend self

    def find_airport_by_code(iata_code)
      airports.find{|x| x.iata_code == iata_code }
    end

    def find_airport_by_id(id)
      airports.find{|x| x.id.to_i == id.to_i }
    end

    def find_airline_by_code(iata_code)
      airlines.find{|x| x.iata_code == iata_code }
    end

    def find_airline_by_id(id)
      airlines.find{|x| x.id.to_i == id.to_i }
    end

    def find_country_by_name(name)
      countries.find{|x| x.name == name }
    end

    def find_airports_by_country(country)
      airports.select{|x| x.country_name == country.name }
    end

    def find_airlines_by_country(country)
      airlines.select{|x| x.country_name == country.name }
    end

    def find_country_by_code(code)
      countries.find{|x| x.iso3166_1_alpha_2 == code }
    end

    def airports
      @airports ||= load('airports.dat', Yakports::Airport)
    end

    def countries
      @countries ||= load('countries.dat', Yakports::Country)
    end

    def airlines
      @airlines ||= load('airlines.dat', Yakports::Airline)
    end

    def load(file, klass)
      read_csv(file).map {|record| klass.new(*record) }
    end

    def read_csv(file)
      CSV.read(ROOT.join('data', file), encoding: "ISO8859-1")
    end
  end
end
