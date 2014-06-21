require 'pathname'

$LOAD_PATH.unshift(Pathname(__FILE__).dirname.join('lib'))

require 'yakports'

run Yakports::API
