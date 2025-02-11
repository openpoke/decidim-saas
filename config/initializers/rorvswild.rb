RorVsWild.start(
  api_key: ENV["RORVSWILD_API_KEY"],
  ignored_exceptions: [
    "ActionController::RoutingError",
    "ActiveRecord::RecordNotFound",
    "Aws::S3::Errors::InvalidRequest"
  ]
) if ENV["RORVSWILD_API_KEY"].present?