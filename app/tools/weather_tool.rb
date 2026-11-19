require "open-uri"

class WeatherTool < RubyLLM::Tool
  description "Get the weather for a specific location"
  param :latitude, desc: "Latitude of a specific location (eg. 48.8566)"
  param :longitude, desc: "Longitude of a specifi location (eg. 2.3522)"

  def execute(latitude:, longitude:)
    # the actual work
    url = "https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
    json = URI.parse(url).read
    return JSON.parse(json)
  end
end
