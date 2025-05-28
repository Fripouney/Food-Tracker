# frozen_string_literal: true
class SpoonacularService
  # Just a bunch of useful methods to call the Spoonacular API
  BASE_URL = "https://api.spoonacular.com"

  def initialize
    @api_key = ENV["SPOONACULAR_API_KEY"]
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |conn|
      conn.headers["Content-Type"] = "application/json"
      conn.adapter Faraday.default_adapter
    end
  end

  def search_ingredients(query, number = 10)
    response = connection.get(
      "food/ingredients/search",
      {
        query: query,
        number: number,
        apiKey: @api_key
      }
    )
    handle_response(response)
  end

  def get_ingredient_information(ingredient_id)
    response = connection.get(
      "food/ingredients/#{ingredient_id}/information",
      {
        apiKey: @api_key
      }
    )
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      raise "Error: #{response.status} - #{response.body}"
    end
  end
end

