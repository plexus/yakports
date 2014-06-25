require 'net/http'
require 'nokogiri'

module WikipediaAirports
  extend self

  def lookup(iata_code)
    @codes ||= {}
    @codes.fetch(iata_code) do
      load(doc_for(iata_code))
      @codes[iata_code]
    end
  end

  def doc_for(code)
    initial = code[0]
    @docs ||= {}
    @docs[initial] ||=
      Net::HTTP.get(URI('http://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_' + initial))
  end

  def load(doc)
    Nokogiri(doc).css('table tr').each do |tr|
      tds = tr.css('td')
      next unless tds[0] && tds[2] && tds[2].css('a').first
      @codes[ tds[0].text ] =  tds[2].css('a').first['href']
    end
  end

end
