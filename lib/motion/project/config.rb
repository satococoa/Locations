class Motion::Project::Config
  def target(platform)
    File.join(platform_dir(platform), 'Developer/SDKs',
              platform + deployment_target + '.sdk')
  end

  def frameworks_dependencies
    @frameworks_dependencies ||=
      begin
        # Compute the list of frameworks, including dependencies, that the project uses.
        deps = []
        slf = File.join(target('iPhoneSimulator'), 'System', 'Library', 'Frameworks')
        frameworks.each do |framework|
          framework_path = File.join(slf, framework + '.framework', framework)
          if File.exist?(framework_path)
            `#{locate_binary('otool')} -L \"#{framework_path}\"`.scan(/\t([^\s]+)\s\(/).each do |dep|               
              # Only care about public, non-umbrella frameworks (for now).
              if md = dep[0].match(/^\/System\/Library\/Frameworks\/(.+)\.framework\/(.+)$/) and md[1] == md[2]
                deps << md[1]
              end
            end
          end
          deps << framework
        end
        deps.uniq
      end
  end
end
