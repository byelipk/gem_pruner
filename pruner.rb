require "rubygems"
require "rubygems/uninstaller"

REGEXP = /(?<name>[a-zA-Z0-9\-\_]+)\s(?<version>.+)/
DRY_RUN = ARGV[0]

def gems_from_stream(data)
  data.split(/\n/).map {|g| REGEXP.match(g)}
end

def names_for(gems)
  gems.map {|g| g["name"]}
end

puts "Determining default gems..."
file = File.open("default_list.txt", "r")
DEFAULT_GEMS = names_for(gems_from_stream(file.read))
file.close

counter = 0

gems_from_stream(`gem list`).compact.each do |g|
  name    = g["name"]
  version = g["version"]
  next if DEFAULT_GEMS.include?(name)

  if DRY_RUN == "--dry-run"
    puts "[DRY RUN] Uninstalled gem #{name} #{version}"
  else
    begin
      uninstaller = Gem::Uninstaller.new(
        name,
        ignore: "-I",
        executables: true
      )

      uninstaller.uninstall

      Gem.post_uninstall do
        puts "Uninstalled gem #{name}"
      end
      counter += 1
    rescue StandardError => e
      puts "Could not uninstall #{name}: #{e}"
    end
  end
end

puts "Gem pruning complete!"
puts "Total gems pruned: #{counter}"
