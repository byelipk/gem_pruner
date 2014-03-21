require "rubygems"
require "rubygems/uninstaller"

puts "Determining default gems..."

# RVM's default gemset
DEFAULT_GEMS = [
  "bigdecimal",
  "bundler", 
  "bundler-unload", 
  "executable-hooks", 
  "gem-wrappers", 
  "io-console", 
  "json", 
  "minitest", 
  "psych", 
  "rake", 
  "rdoc", 
  "rubygems-bundler", 
  "rvm", 
  "test-unit"
]

counter = 0

`gem list > gems_to_uninstall.txt`
File.open("gems_to_uninstall.txt", "r") do |f|
  f.readlines.each do |line|
    my_gem = line.chomp.split(/ /).first
    next if DEFAULT_GEMS.include?(my_gem)
    
    begin
      Gem::Uninstaller.new(my_gem, ignore: "-I" ).uninstall
      puts "Uninstalled gem #{my_gem}!"
      counter += 1
    rescue StandardError => e
      puts "Could not uninstall #{my_gem}: #{e}"
    end
  end
end
`rm -f gems_to_uninstall.txt`

puts "Gem pruning complete!" 
puts "Total gems pruned: #{counter}"
