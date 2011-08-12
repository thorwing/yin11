# config/initializers/geocoder.rb

# geocoding service (see below for supported options):
#TODO
Geocoder::Configuration.lookup = :yahoo

# to use an API key:
# for http://yinkuaizi.com
# Geocoder::Configuration.api_key = "ABQIAAAAzu7CXt92NZgriHar1AhtRRT2H37VFXvrvhgIRNtmutCmy1bfIRQF2i-4uacF69HsVG3ToxsI9xDRkQ"

# geocoding service request timeout, in seconds (default 3):
# Geocoder::Configuration.timeout = 10

# use HTTPS for geocoding service connections:
# Geocoder::Configuration.use_https = true

# language to use (for search queries and reverse geocoding):
Geocoder::Configuration.language = "zh-CN"

# use a proxy to access the service:
# Geocoder::Configuration.http_proxy  = "127.4.4.1"
# Geocoder::Configuration.https_proxy = "127.4.4.2" # only if HTTPS is needed

# caching (see below for details)
#TODO
Geocoder::Configuration.cache = Hash.new()
# Geocoder::Configuration.cache_prefix = "..."