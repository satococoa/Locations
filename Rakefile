$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require './lib/motion/project/config'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Locations'
  # app.deployment_target = '4.3'
  app.frameworks += [
    'CoreLocation', 'CoreData'
  ]
end
