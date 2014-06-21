module Yakports
  class API < Grape::API

    default_format :hal

    class Formatter
      def call(object, env)
        Yakports.yaks.serialize(object, env: env)
      end
    end

    Yaks::Serializer.mime_types.each do |name, mime_type|
      content_type name, mime_type
      formatter name, Formatter.new
    end

    get 'airports/:code_or_id' do
      if params[:code_or_id] =~ /\A\d+\z/
        Repository.find_airport_by_id(params[:code_or_id])
      else
        Repository.find_airport_by_code(params[:code_or_id])
      end
    end

    get 'countries/:iso_code' do
      Repository.find_country_by_code(params[:iso_code])
    end

    get 'countries/:iso_code/airports' do
      env['api.exclude'] = [:country]
      Repository.find_country_by_code(params[:iso_code]).airports
    end

    get 'countries/:iso_code/airlines' do
      env['api.exclude'] = [:country]
      Repository.find_country_by_code(params[:iso_code]).airlines
    end

  end
end
