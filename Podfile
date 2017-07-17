
platform :ios, :deployment_target => "9.0"


def swift_pods
    use_frameworks!
    pod 'SnapKit'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'FirebaseUI/Database'
end

def testing_pods
    use_frameworks!
    pod 'Nimble'
end

target 'personneldb' do
    swift_pods
end

target 'personneldbTests' do
	swift_pods
    testing_pods
end

target 'personneldbUITests' do
    testing_pods
end
