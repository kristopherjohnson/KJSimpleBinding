# KJSimpleBinding

`KJSimpleBinding` is a library that makes it easy to use [key-value coding](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html) (KVC) and [key-value observing](https://developer.apple.com/library/mac/#documentation/cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) (KVO) for simple data-binding scenarios in iOS applications.

The library is inspired by Mac OS X's [Cocoa Bindings](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaBindings/CocoaBindings.html) mechanism, but only implements a small subset of its functionality. The data bindings provided by `KJSimpleBinding` are one-way only: that is, the library handles updating user-interface elements automatically when a model object's property changes, but changes to the UI element will not result in an automatic change to the model object.  The `KJSimpleBinding` library currently does not support value transformers or formatters.


## Contents

The following targets are provided in an Xcode workspace:

- `KJSimpleBinding` - a static library that provides the `KJBindingManager` class. You can copy this library into your own projects, or just copy the `.h` and `.m` file.
- `KJSimpleBindingTests` - unit tests for the `KJSimpleBinding` library. To run the tests, select the `KJSimpleBinding` scheme in Xcode and then choose the *Product* > *Test* menu item.
- `KJSimpleBindingDemo` - a simple iOS application that demonstrates use of `KJBindingManager`.


## Using KJBindingManager

Create a `KJBindingManager` instance like this:

    bindingManager = [[KJBindingManager alloc] init];
    
Set up bindings by calling the `-bindObserver:keyPath:toSubject:keyPath:` method.

    [_bindingManager bindObserver:myLabel       keyPath:@"text"
                        toSubject:myModelObject keyPath:@"stringProperty"];

In this example, the value of `myLabel.text` will be updated whenever `myModelObject.stringProperty` is set to a new value.

The observer must be [KVC-compliant](http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/Compliant.html) for the specified key path, and the subject must be [KVO-compliant](http://developer.apple.com/library/ios/#DOCUMENTATION/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html) for the specified key path. The observer and subject properties must have compatible types; an attempt to bind a numeric property to a string property or vice versa will cause a runtime exception.

Note that `-bindObserver:keyPath:toSubject:keyPath:` does not retain the observer or subject, so it is up to the caller to guarantee that those object references stay valid.

The binding manager must be _enabled_ before it will start performing the observation/update behavior.  It is recommended that it be enabled in the view controller's `viewWillAppear:` method, and then disabled in the `viewWillDisappear:` method, so that the overhead of observation applies only while the bound objects are onscreen:

    - (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [_bindingManager enable];
    }

    - (void)viewWillDisappear:(BOOL)animated {
        [_bindingManager disable];
        [super viewWillDisappear:animated];
    }

Call the `-removeAllBindings` method to remove the bindings.  It is good style to call this before releasing the binding manager, but it will automatically be done if the binding manager is deallocated while it has active bindings.

See the [KJSimpleBindingDemo](http://github.com/kristopherjohnson/KJSimpleBinding/blob/master/KJSimpleBindingDemo/ViewController.m) sample code for a complete example.


## Future Directions

The following features are planned:

- Validation
- Value transformers and/or data formatters

Note that a full Cocoa Bindings implementation is not feasible on iOS, due to limitations of UIKit components.


## License

Copyright &copy; 2012 Kristopher Johnson
 
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
