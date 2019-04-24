#
# Be sure to run `pod lib lint RevanKits.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RevanKits'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RevanKits.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RevanKits收集的是项目开发中必要的分类、常量、网络工具类等等
                       DESC

  s.homepage         = 'https://github.com/RevanWang/RevanKits'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RevanWang' => 'zjqx1991@163.com' }
  s.source           = { :git => 'https://github.com/RevanWang/RevanKits.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
    s.subspec 'Category' do |c|
        c.source_files = 'RevanKits/Classes/Category/**/*'
    end

    s.subspec 'Base' do |b|
        b.source_files = 'RevanKits/Classes/Base/**/*'
    end

    s.subspec 'Tool' do |t|
        t.source_files = 'RevanKits/Classes/Tool/**/*'
    end
  
    s.subspec 'Network' do |network|
      network.source_files = 'RevanKits/Classes/Network/**/*.{h,m}'
      network.dependency 'AFNetworking'
      network.dependency 'MJExtension'
    end
    
    s.subspec 'BaseMVC' do |bmvc|
        bmvc.source_files = 'RevanKits/Classes/BaseMVC/**/*.{h,m}'
        bmvc.resource_bundles = {
            'BaseMVCSource' => ['RevanKits/Classes/BaseMVC/**/*.xib', 'RevanKits/Assets/**/*.xcassets']
        }
        bmvc.dependency 'MJRefresh'
        bmvc.dependency 'RevanKits/Network'
    end

  #s.source_files = 'RevanKits/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RevanKits' => ['RevanKits/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
