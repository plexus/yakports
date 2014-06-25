require 'pathname'

$LOAD_PATH.unshift(Pathname(__FILE__).dirname.join('lib'))

require 'yakports'

use Rack::Static,
  :urls => ["/js", "/vendor", "/styles.css", "/browser.html"],
  :root => "public"

run Yakports::API
