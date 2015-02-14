# Surf Forcaster by Max Helmetag
# Take user input and returns the current surf info from Surfline.com

require 'rubygems'
require 'mechanize'
require 'action_mailer'
require 'pony'
require 'sms_fu'

def remove_html_tags(string)
  # Regex for stripping html from Xpath retrieved info
  re = /<("[^"]*"|'[^']*'|[^'">])*>/
  string.gsub!(re, '')
end

# Get forecast from surfline at the available locations
# Declare constant URLs and Xpaths
SOCAL_FORCASTS = "http://www.surfline.com/surf-forecasts/southern-california/"
FIRST_DAY_WAVE_HEIGHT = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[1]/div[3]/div/div[1]/h1"
SECOND_DAY_WAVE_HEIGHT = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[2]/div[3]/div/div[1]/h1"
THRID_DAY_WAVE_HEIGHT = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[3]/div[3]/div/div[1]/h1"
FIRST_DAY_RATING = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[1]/div[1]/strong"
SECOND_DAY_RATING = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[2]/div[1]/strong"
THIRD_DAY_RATING = "//div[@id='observed_component']/div[3]/div[1]/div[1]/div/div[3]/div[1]/strong"
SANTA_BARBARA = "santa-barbara_2141/"
VENTURA = "ventura_2952/"
N_LOS_ANGELES = "north-los-angeles_2142"

# Initialize Mechanize to retrieve data from Xpaths
post_agent = Mechanize.new

# Initialize sms_fu
sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)

# Start Forcaster program
# Get name
puts "Please enter your name."
print "> "
name = gets.chomp

# Get location and create surfine page URL based on location
puts "Please enter your location for forcasting."
puts "The current location offerings are: Santa Barbara (SB), Ventura (V) and North Los Angeles (NLA)"
print "> "
location = gets.chomp

# Get mobile number
puts "Please enter your mobile number."
print "> "
mobileNumber = gets.chomp

# Get carrier
puts "Please enter your carrier."
print "> "
carrier = gets.chomp

# Get minimum rating
puts "Please enter your minimum rating. A valid entry is a numbers between 1 (flat) to 10 (epic)."
print "> "
minimumRating = gets.chomp.to_i

# Match input location to URL constant
# TODO: Map for locations and URL constants
case (location)
  when "SB"
    area = "Santa Barbara"
    post_page = post_agent.get(SOCAL_FORCASTS + SANTA_BARBARA)
  when "V"
    area = "Ventura"
    post_page = post_agent.get(SOCAL_FORCASTS + VENTURA)
  when "NLA"
    area = "North Los Angeles"
    post_page = post_agent.get(SOCAL_FORCASTS + N_LOS_ANGELES)
end

# TODO: Make remove_html_tags a .method versus a method()
# Change wave height objects to string and strip surrounding html
firstDayWaveHeight = post_page.parser.xpath(FIRST_DAY_WAVE_HEIGHT).to_s
firstDayWaveHeight = remove_html_tags(firstDayWaveHeight)
secondDayWaveHeight = post_page.parser.xpath(SECOND_DAY_WAVE_HEIGHT).to_s
secondDayWaveHeight = remove_html_tags(secondDayWaveHeight)
thirdDayWaveHeight = post_page.parser.xpath(THRID_DAY_WAVE_HEIGHT).to_s
thirdDayWaveHeight = remove_html_tags(thirdDayWaveHeight)

# Change rating objects to string and strip surrounding html
firstDayRating = post_page.parser.xpath(FIRST_DAY_RATING).to_s
firstDayRating = remove_html_tags(firstDayRating)
secondDayRating = post_page.parser.xpath(SECOND_DAY_RATING).to_s
secondDayRating = remove_html_tags(secondDayRating)
thirdDayRating = post_page.parser.xpath(THIRD_DAY_RATING).to_s
thirdDayRating = remove_html_tags(thirdDayRating)

# Map ratings to a numerical scale for easier comparison
SURFLINE_RATINGS_MAP = {
  "flat" => 1,
  "very poor" => 2,
  "poor" => 3,
  "poor to fair" => 4,
  "fair" => 5,
  "fair to good" => 6,
  "good" => 7,
  "very good" => 8,
  "good to epic" => 9,
  "epic" => 10,
}

firstDayNumericalRating = 0
SURFLINE_RATINGS_MAP.each do |rating, numerical|
  firstDayNumericalRating = numerical if rating == firstDayRating
end

# Compares day rating to minimum rating
if firstDayNumericalRating >= minimumRating
  # Makes random surf messages with info
  rand = rand(10)
  case (rand)
    when 1..3
      forecast = "Whats up, " + name + "? Today in " + area + ", the waves are " + firstDayWaveHeight + " and the conditons are " + firstDayRating + "."
    when 4..6
      forecast = "Whoa, " + name + "!! Duuude, it's firing in " + area + "! Grab your best shredstick for " + firstDayWaveHeight + " waves. It looks super " + firstDayRating + "!"
    when 7..9
      forecast = "Poseidon has granted you a most glorious day, " + name + ". The shimmering walls of water are " + firstDayWaveHeight + ". Celebrate his " + firstDayRating + " demonstration of power!"
  end
else
  forecast = "The surf isn't worth it. No reason to take a day off work."
end

sms_fu.deliver(mobileNumber, carrier, forecast)
