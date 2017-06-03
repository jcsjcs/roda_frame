# require "logger"
#
# @_repl_namespace = :RodaFrame
#
# @snakecase_name = @_repl_namespace.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
# @_app_files_ = Dir["./#{@snakecase_name}.rb", "./lib/**/*.rb"]
# routes = Dir["./routes/**/*.rb"]
#
# Pry.config.requires = @_app_files_.concat routes
# Pry.config.prompt_name = "#{@snakecase_name}_dev"
#
# Logger.new $stdout
#
# Pry.config.exec_string="@app = Object.const_get('#{@_repl_namespace}').new('for_pry')"

begin
  require 'pry-clipboard'
  # aliases
  Pry.config.commands.alias_command 'ch', 'copy-history'
  Pry.config.commands.alias_command 'cr', 'copy-result'
rescue LoadError => e
  warn "can't load pry-clipboard: #{e}"
end

# def app
#   RodaFrame.new('for_pry')
# end

# class Hld
#   include CommonHelpers
# end
#
# def ld_help
#   Hld.new
# end

# def _reload(namespace=@_repl_namespace, files=@_app_files_)
#   Object.send(:remove_const, namespace)
#   files.each(&method(:load))
#   _load namespace
# end
#
# def _load(namespace=@_repl_namespace)
#   # include Object.const_get(namespace)
#   # app = Object.const_get(namespace).new('for_pry')
#   $stdout.puts "\e[4;36m\#{namespace}\e[0m"
#   true
# end
