module Yakports
  class Country < Struct.new(*DATA_FORMATS[:countries])
    def airports
      Repository.find_airports_by_country(self)
    end

    def airlines
      Repository.find_airlines_by_country(self)
    end
  end

  class Airline < Struct.new(*DATA_FORMATS[:airlines])
    def country
      Repository.find_country_by_name(country_name)
    end
  end

  class Airport < Struct.new(*DATA_FORMATS[:airports])
    def country
      Repository.find_country_by_name(country_name)
    end
  end
end
