Pod::Spec.new do |s|
  s.name         = "XYMediaPlayer"
  s.version      = "1.0.1"
  s.summary      = "音频播放器,视频播放器，字幕"

  # 项目主页地址
  s.homepage     = "https://github.com/wusang/XYMediaPlayer.git"
 
  # 许可证
  s.license      = "MIT"
 
  # 作者
  s.author             = { "wusang" => "1149779588@qq.com" }
 

  # 支持平台
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  # 项目的地址
  s.source       = { 
            :git => "https://github.com/wusang/XYMediaPlayer.git", 
            :tag => s.version 
  }

  # 头文件
  s.source_files  = "XYMediaPlayer/XYMediaPlayer.h"
  # 资源文件
  s.resources = "XYMediaPlayer/XYMediaPlayer.bundle"
  # 下级文件
  s.source_files = "XYMediaPlayer/*.{h,m}"

  s.subspec "Audio" do |ss|
  ss.source_files =  "XYMediaPlayer/Audio/*.{h,m}"
  end

  # 是否支持ARC 
  s.requires_arc = true

  s.dependency 'XYExtensions'
  s.dependency 'MJExtension'
  s.dependency 'Masonry'
  s.dependency 'XYAlertHUD'
  
end
