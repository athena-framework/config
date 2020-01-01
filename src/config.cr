require "yaml"

require "./base"

# Convenience alias to make referencing `Athena::Config` types easier.
alias ACF = Athena::Config

module Athena::Config
  VERSION = "0.1.0"

  # The name of the environment variable that stores the path to the configuration file.
  CONFIG_PATH_NAME = "ATHENA_CONFIG_PATH"

  # The default path to the configuration file.
  DEFAULT_CONFIG_PATH = "./athena.yml"

  class_getter config : ACF::Base { ACF.load }

  def self.config_path : String
    ENV[CONFIG_PATH_NAME]? || DEFAULT_CONFIG_PATH
  end

  def self.config_path=(path : String) : Nil
    ENV[CONFIG_PATH_NAME] = path
  end

  protected def self.load : ACF::Base
    # TODO: Handle ENV vars and params
    ACF::Base.from_yaml {{read_file env(CONFIG_PATH_NAME) || DEFAULT_CONFIG_PATH}}
  rescue ex : YAML::ParseException
    raise "Error parsing Athena configuration file(#{ACF.config_path}): '#{ex.message}'"
  end
end
