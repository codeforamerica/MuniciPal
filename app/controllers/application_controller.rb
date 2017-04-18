class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if !ENV['THEME'].blank?
    before_action :prepend_view_paths
  end

  def prepend_view_paths
    # See .env.sample for info on setting & using a theme.
    theme_dir = Rails.root + "app/views/themes/#{ENV['THEME']}"
    # puts "prepending theme dir: #{theme_dir}"
    prepend_view_path theme_dir
  end
end
