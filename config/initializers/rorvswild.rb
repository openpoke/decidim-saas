RorVsWild.start(
  api_key: ENV["RORVSWILD_API_KEY"],
  ignored_exceptions: [
    "ActionController::RoutingError",
    "ActiveRecord::RecordNotFound",
    "ActionView::MissingTemplate"
  ]
) if ENV["RORVSWILD_API_KEY"].present?