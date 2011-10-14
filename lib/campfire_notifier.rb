require 'yaml'

require 'rubygems'
require 'httparty'
require 'json'

class CampfireNotifier
  include HTTParty

  headers     'Content-type' => 'application/json'
  format      :json


  # Accepts either a string filename, a hash of options, or defaults to trying
  # to read configuration options from a default yaml file.
  #
  # Attempts to load configuration options from a passed in options hash or
  # loads configuration options from a file.
  def self.config(opts = nil)
    @config ||= opts.is_a?(Hash) ? opts : load_file(opts)
  end

  def self.speak(message)
    base_uri    "https://#{config['subdomain']}.campfirenow.com"
    basic_auth  config["token"], 'x'
    post "/room/#{config['room_id']}/speak.json", :body => { :message => { :body => message, :type => 'Textmessage' } }.to_json
  end

  private
    def self.default_config_file
      '~/.campfire_notifier.yml'
    end

    def self.load_file(filename)
      YAML.load_file(File.expand_path(filename || default_config_file))
    end

end
