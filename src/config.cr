require "yaml"

require "./base_config"

# Convenience alias to make referencing `Athena::Config` types easier.
alias ACF = Athena::Config

module Athena::Config
  VERSION = "0.1.0"

  # The name of the environment variable that stores the path to the configuration file.
  CONFIG_PATH_NAME = "ATHENA_CONFIG_PATH"

  # The default path to the configuration file.
  DEFAULT_CONFIG_PATH = "./athena.yml"

  class_getter config : ACF::Config { ACF.load }

  def self.config_path : String
    ENV[CONFIG_PATH_NAME]? || DEFAULT_CONFIG_PATH
  end

  def self.config_path=(path : String) : Nil
    ENV[CONFIG_PATH_NAME] = path
  end

  private def def self.load : ACF::Config
    # TODO: Handle ENV vars and params
    ACF::Config.from_yaml {{read_file ENV[CONFIG_PATH_NAME]? || DEFAULT_CONFIG_PATH}}
  rescue ex : YAML::ParseException
    raise "Error parsing Athena configuration file(#{ACF.config_path}): '#{ex.message}'"
  end
end
