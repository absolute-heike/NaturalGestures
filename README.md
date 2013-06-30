NaturalGestures
===============

Swipe, Rotate and Pinch a View between two states with just **one method call**.
You can even add a block to dynamically tweak the UI according to the current scale.

[![screencast](https://dl.dropboxusercontent.com/u/89042933/NaturalGesturesVideoPreview.png)](https://www.youtube.com/watch?v=ErrED69Ij5k)

```objc
#import "MBNaturalGestures.h"

[self.theView addNaturalGesturesFromBounds:self.theView.bounds toBounds:toBounds completion:^(BOOL shouldClose) {
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
- in case aspect ratio of the 2 uiview states is the same, you could just set the view transform instead, which would be much better and faster in that case
- example project could be better
- ??? I am thrilled, what you guys come up with :)

Posted for the [Objective-C hackathon](https://objectivechackathon.appspot.com/)


LICENSE
========
Copyright (c) 2013 Michael Berg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
