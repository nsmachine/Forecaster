source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

workspace 'Forecaster.xcworkspace'

def sdkPods_universal
	
    # Both iOS and watchOS compatible pods here.

    pod 'Alamofire'
    pod 'RealmSwift'
    pod 'SwiftyJSON'
    pod 'RxSwift'
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'

end

target 'ForecasterSDKTests' do

	project './ForecasterSDK'
    platform :ios, '10.0'

    sdkPods_universal
    
end

target 'ForecasterSDK' do

	project './ForecasterSDK'
    platform :ios, '10.0'

    sdkPods_universal
    
end

target 'ForecasterSDKTestsHost' do

    project './ForecasterSDK'
    platform :ios, '10.0'

    sdkPods_universal
    
end

target 'Forecaster' do

	project './Forecaster'
	platform :ios, '10.0'

	sdkPods_universal
end
