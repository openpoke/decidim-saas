RorVsWild.start(
  api_key: ENV["RORVSWILD_API_KEY"],
  ignore_exceptions: [
    "ActionController::RoutingError",
    "ActiveRecord::RecordNotFound",
    "ActionView::MissingTemplate",
    "ActionController::InvalidCrossOriginRequest",
    "ActionController::InvalidAuthenticityToken"
  ]
) if ENV["RORVSWILD_API_KEY"].present?