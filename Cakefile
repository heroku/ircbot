require.paths.unshift "#{__dirname}/node_modules"

{spawn, exec} = require 'child_process'
print = (data) -> console.log data.toString()

task 'dev', "Continuously build CoffeeScript source files", ->
  coffee = spawn 'coffee', ['-cw', '-o', 'lib', 'src']
  coffee.stdout.on 'data', print
  coffee.stderr.on 'data', print

task 'build', "Build CoffeeScript source files", ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', print
  coffee.stderr.on 'data', print
