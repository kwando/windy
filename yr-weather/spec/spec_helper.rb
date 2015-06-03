# add lib to load path
path = File.join(File.expand_path('..', File.dirname(__FILE__)), 'lib')
$: << path

require 'yr-weather'
