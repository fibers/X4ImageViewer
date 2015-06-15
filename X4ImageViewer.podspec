Pod::Spec.new do |s|
  s.name             = "X4ImageViewer"
  s.version          = "1.0.0"
  s.summary          = "A ios easy-to-use image viewer."
  s.description      = "A ios easy-to-use image viewer."
  s.homepage         = "https://github.com/fibers/X4ImageViewer"
  s.license          = 'GNU General Public license v2.0'
  s.author           = {"fibers" => "yu8582@gmail.com" }
  s.source           = { :git => "https://github.com/fibers/X4ImageViewer.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'X4ImageViewer/*'
  # s.resources = 'Assets'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
