class LocationsController < ApplicationController

  def get_states # POST
    country = Country.find_by_code(params[:country_id])
    @states = country.states.order("name")
    render partial: "get_states", locals: { states: @states }
  end

  def get_cities # POST
    country = Country.find_by_code(params[:country_id])
    @cities = country.cities
    city = params[:city_id] ? params[:city_id] : "" 
    render partial: "get_cities", locals: { cities: @cities, city: city }
  end

  def search_city
    country = Country.find_by_code(params[:country_id])

    cities = country.cities.where("Name LIKE ?", "#{params[:term]}%" ).order("Name")

    result = cities.map{ | city | { value: city.name } }

    render json: result
  end
end
