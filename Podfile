# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

plugin 'cocoapods-keys', {
  :project => "SimplED",
  :target => "SimplED",
  :keys => [
    "CloudinaryAPIKey",
    "CloudinaryAPISecretKey"
  ]
}

target 'SimplED' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Cloudinary', '~> 2.0'

  # Pods for SimplED

  target 'SimplEDTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SimplEDUITests' do
    # Pods for testing
  end

end
