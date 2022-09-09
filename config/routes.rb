Rails.application.routes.draw do
  post "/smith_syndrome", to: "risk#smith_syndrome"
end
