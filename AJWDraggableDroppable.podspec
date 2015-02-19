Pod::Spec.new do |s|

  s.name = 'AJWDraggableDroppable'
  s.version = '0.0.1'
  s.summary = 'AJWDraggableDroppable provides a drag and drop API for iOS.'

  s.description = <<-DESC
AJWDraggableDroppable provides a rich drag and drop API for iOS apps.

A draggable view can be moved with user interaction. A droppable view provides an area in which a draggable view can be dropped. AJWDraggableDroppable allows you to identify a view as a draggable or droppable, and provides a mechanism for responding to events involving the two.

Features:
- Identify a view as draggable or droppable in a single line.
- Add draggable behaviour to a view without having to go through the routine `UIPanGestureRecognizer` rigmarole.
- Respond to events involving draggable and droppable views (example: a draggable was dropped on a droppable).
- Apply visual states to draggable and droppable views during the different phases of a drag and drop gesture.
- Animate a draggable view back to it's starting location, or a defined drop location with UIKitDynamics snap behaviours.
- Manage separate collections of draggable and droppable views.
  DESC

  s.homepage = 'https://github.com/adamwaite/AJWDraggableDroppable'

  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.author = { 'Adam Waite' => 'adam@adamjwaite.co.uk' }

  s.social_media_url = 'http://twitter.com/AdamWaite'

  s.platform = :ios, '7.0'

  s.requires_arc = true

  s.source = { :git => 'https://github.com/adamwaite/AJWDraggableDroppable.git', branch: 'master', tag: '0.0.1' }

  s.source_files = 'AJWDraggableDroppable', 'AJWDraggableDroppable/**/*.{h,m}'

  s.public_header_files = 'AJWDraggableDroppable/AJWDraggableDroppable.h',
    'AJWDraggableDroppable/AJWDraggableView.h',
    'AJWDraggableDroppable/AJWDroppableView.h',
    'AJWDraggableDroppable/AJWDraggableDroppableDelegate.h',
    'AJWDraggableDroppable/UIView+AJWDraggable.h',
    'AJWDraggableDroppable/UIView+AJWDroppable.h'

end
