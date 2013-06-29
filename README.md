NaturalGestures
===============

Swipe, Rotate and Pinch a View between two states with just **one method call**.
You can even add a block to dynamically tweak the UI according to the current scale.

```objc
#import "MBNaturalGestures.h"

[self.theView addNaturalGesturesWithFromBounds:self.theView.bounds toBounds:toBounds completion:^(BOOL shouldClose) {
    if(shouldClose) {
      //animate to close-state of the View
    } else {
      //animate to open-state of the View
    }
}];

[self.theView.naturalGestureHandler setScaleDidChangeBlock:^(CGFloat scale) {
    anotherView.alpha = scale;
}];
```

Example
=======

An example App is included.

![demo](https://dl.dropboxusercontent.com/u/89042933/NaturalGestures1.jpg)



--------------
#### possible improvements ####
- in case you don't need the 2 uiview states, you could just set the view transform instead, which would be much better in this case
- example project could be better
- ??? I am thrilled, what you guys come up with :)

Posted for the [Objective-C hackathon](https://objectivechackathon.appspot.com/)
