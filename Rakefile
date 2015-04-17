
desc "Update the CoffeeScript Javascript."
task :update do
  # sh("git show master:src/coffeelint.coffee | node_modules/.bin/coffee --stdio --print > js/coffeelint.js")
  puts "WARNING: 'rake update' does not update coffeelint.js any more."
  puts "It has to be done manually before running rake update"
  puts ""
  puts "git checkout master &&"
  puts "npm run compile &&"
  puts "git checkout gh-pages &&"
  puts "cp lib/coffeelint.js js/coffeelint.js &&"
  puts "rake updatehtml"
end

task :updatehtml do
  sh("cat default-top.html > new_index.html && cat index-src.html >> new_index.html && cat default-bottom.html >> new_index.html && mv new_index.html index.html")
  sh("git show master:src/htmldoc.coffee > js/htmldoc.coffee && cat default-top.html > new_options.html && cat options-top.html >> new_options.html && coffee js/htmldoc.coffee >> new_options.html && cat options-bottom.html >> new_options.html && cat default-bottom.html >> new_options.html && mv new_options.html options.html && rm js/htmldoc.coffee")
  sh("cat default-top.html > new_about.html && cat about-src.html >> new_about.html && cat default-bottom.html >> new_about.html && mv new_about.html about.html")
  sh("cat default-top.html > new_api.html && cat api-src.html >> new_api.html && cat default-bottom.html >> new_api.html && mv new_api.html api.html")
  sh("cat default-top.html > new_changelog.html && cat changelog-src.html >> new_changelog.html && cat default-bottom.html >> new_changelog.html && mv new_changelog.html changelog.html")
end
