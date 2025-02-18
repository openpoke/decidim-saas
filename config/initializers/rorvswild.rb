RorVsWild.start(
  api_key: ENV["RORVSWILD_API_KEY"],
  ignore_exceptions: [
    "ActionController::RoutingError",
    "ActiveRecord::RecordNotFound",
    "ActionView::MissingTemplate",
    "ActionController::InvalidCrossOriginRequest",
    "ActionController::InvalidAuthenticityToken"
  ],
  deployment: {
    revision: ENV["APP_REVISION"]
  }
) if ENV["RORVSWILD_API_KEY"].present?