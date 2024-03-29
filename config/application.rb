require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module SnaptivistWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.assets.initialize_on_precompile = false

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    #config.active_record.whitelist_attributes = false

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.assets.paths << Rails.root.join("app", "assets", "images", "mail")
    config.assets.paths << Rails.root.join("public", "mobile", "images")
    #config.assets.paths << Rails.root.join("public", "mobile", "javascripts")
    #config.assets.paths << Rails.root.join("public", "mobile", "stylesheets")
    config.assets.paths << Rails.root.join("public", "mobile", "images")

    config.assets.paths << Rails.root.join('public', 'merchants', 'assets')

    config.assets.paths << Rails.root.join("app", "assets", "images", "mobile", "media_images")
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/api/*)
    
    # via https://github.com/sstephenson/sprockets/issues/347#issuecomment-25543201
    # We don't want the default of everything that isn't js or css, because it pulls too many things in
    config.assets.precompile.shift

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
        '.html', '.erb', '.haml',                 # Templates
        '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
        '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
      ]
    end)

    config.middleware.use Rack::Cors do
        allow do
          origins '*'
          # location of your API
          resource '/*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
        end
    end

    config.middleware.use(Rack::Config) do |env|
        env['api.tilt.root'] = Rails.root.join "app", "views", "api"
    end

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

  end

  
  class Util
    # Method to build a config hash from a YAML file.
    # an array with a Settings hash and a required_settings
    # array is returned.
    def self.config2hash(file)
      hash = YAML.load(ERB.new(File.read(file)).result)

      # Read all the settings that are under the common block.
      common_hash = hash['common'] || {}
      required_settings = common_hash.keys
      
      # These are all the settings based on the environment you are in.
      env_hash = hash[Rails.env.to_s] || {}

      # Combine the common settings and the env specific setting together.
      final_hash = common_hash.deep_merge(env_hash)
      [Hashr.new(final_hash), required_settings]
    end
  end
end

# Read in the settings.yml file from the config directory.  Save it in the processed_settings array...
processed_settings = SnaptivistWeb::Util.config2hash(Rails.root.join('config', 'settings.yml'))

# These are settings from the settings.yml file that are in the common block.
Settings = processed_settings[0]

# These are just the keys from the common block in the settings.yml file.
REQUIRED_SETTINGS = processed_settings[1]
