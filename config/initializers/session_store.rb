options = { :key => '_alive_session' }

# options = { :key => '_alive_{{username}}_session' }
# options[:domain] = '{{username}}.com' if Rails.env.production?

Rails.application.config.session_store :cookie_store, options
