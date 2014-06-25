module Yakports
  class API < Grape::API

    default_format :hal

    class Formatter
      def call(object, env)
        if object == :top_level
          Yakports.yaks.serialize(object, env: env, mapper: RootMapper)
        else
          Yakports.yaks.serialize(object, env: env)
        end
      end
    end

    Yaks::Serializer.mime_types.each do |name, mime_type|
      content_type name, mime_type
      formatter name, Formatter.new
    end

    get do
      :top_level
    end

    resource 'airports' do
      get do
        Repository.airports
      end

      get ':code_or_id' do
        if params[:code_or_id] =~ /\A\d+\z/
          Repository.find_airport_by_id(params[:code_or_id])
        else
          Repository.find_airport_by_code(params[:code_or_id])
        end
      end

      get ':code_or_id' do
        if params[:code_or_id] =~ /\A\d+\z/
          Repository.find_airline_by_id(params[:code_or_id])
        else
          Repository.find_airline_by_code(params[:code_or_id])
        end
      end
    end

    resource 'countries' do
      get do
        Repository.countries
      end

      get ':iso_code' do
        Repository.find_country_by_code(params[:iso_code])
      end

      get ':iso_code/airports' do
        Repository.find_country_by_code(params[:iso_code]).airports
      end

      get ':iso_code/airlines' do
        Repository.find_country_by_code(params[:iso_code]).airlines
      end
    end

    resource 'airlines' do
      get do
        Repository.airports
      end
    end

  end
end
