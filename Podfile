platform :ios, '9.0'

use_frameworks!

target 'TheLightShop' do
    
    pod 'Moltin'
    pod 'SwiftSpinner'
    pod 'SDWebImage'
    pod 'CardIO'
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
