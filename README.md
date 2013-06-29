NaturalGestures
===============

Swipe, Rotate and Pinch a View between two states with just one method call.
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

![demo](https://dl.dropboxusercontent.com/u/89042933/NaturalGestures1.png)
![demo](https://dl.dropboxusercontent.com/u/89042933/NaturalGestures2.png)


