Pod::Spec.new do |s|

  s.name = 'AJWDraggableDroppable'
  s.version = '0.0.0.1'
  s.summary = 'AJWDraggableDroppable provides a drag and drop API for iOS apps.'

  s.description = <<-DESC

  DESC

  s.homepage = 'https://github.com/adamwaite/AJWDraggableDroppable'

  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.author = { 'Adam Waite' => 'adam@adamjwaite.co.uk' }

  s.social_media_url = 'http://twitter.com/AdamWaite'

  s.platform = :ios, '7.0'

  s.source = { :git => 'https://github.com/adamwaite/AJWDraggableDroppable.git', tag: 'v0.0.0.1' }

  s.source_files = 'AJWDraggableDroppable', 'AJWDraggableDroppable/**/*.{h,m}'

  s.public_header_files = 'AJWDraggableDroppable/AJWDraggableDroppable.h', 'AJWDraggableDroppable/AJWDraggableView.h', 'AJWDraggableDroppable/AJWDroppableView.h', 'AJWDraggableDroppable/AJWDraggableDroppableDelegate.h', 'AJWDraggableDroppable/UIView+AJWDraggable.h', 'AJWDraggableDroppable/UIView+AJWDroppable.h'

  s.requires_arc = true

end
