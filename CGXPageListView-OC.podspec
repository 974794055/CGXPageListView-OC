Pod::Spec.new do |s|
s.name         = "CGXPageListView-OC"    #存储库名称
s.version      = "0.0.3"      #版本号，与tag值一致
s.summary      = "a CGXPageListView-OC 菜单封装"  #简介
s.description  = "(左右滚动列表页  封装"  #描述
s.homepage     = "https://github.com/974794055/CGXPageListView-OC"      #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
s.author             = { "974794055" => "974794055@qq.com" }  #作者
s.platform     = :ios, "8.0"                  #支持的平台和版本号
s.source       = { :git => "https://github.com/974794055/CGXPageListView-OC.git", :tag => s.version }         #存储库的git地址，以及tag值
s.requires_arc = true #是否支持ARC
s.frameworks = 'UIKit'

s.source_files = "CGXPageListView", "CGXPageListView/**/*.{h,m}" #需要托管的源代码路径

end




