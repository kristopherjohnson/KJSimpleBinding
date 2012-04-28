//
//  ViewController.m
//  KJSimpleBindingDemo
//
// Copyright (C) 2012 Kristopher Johnson
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ViewController.h"

@implementation ViewController

@synthesize hoursLabel;
@synthesize minutesLabel;
@synthesize secondsLabel;
@synthesize intervalLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Start the clock, which will start ticking, updating its properties as the time changes
    if (_clock == nil) {
        _clock = [[Clock alloc] init];
        [_clock start];
    }
    
    // Bind text labels to properties of the clock.
    // As the clock ticks, the labels will automatically be updated.
    
    _bindingManager = [[KJBindingManager alloc] init];
    
    [_bindingManager bindObserver:hoursLabel keyPath:@"text"
                        toSubject:_clock keyPath:@"hours"];
    
    [_bindingManager bindObserver:minutesLabel keyPath:@"text"
                        toSubject:_clock keyPath:@"minutes"];
    
    [_bindingManager bindObserver:secondsLabel keyPath:@"text"
                        toSubject:_clock keyPath:@"seconds"];    
    
    // timeIntervalSince1970 is a numeric (double) property, so we need
    // to transform it to an NSString for display.
    
    [_bindingManager bindObserver:intervalLabel keyPath:@"text"
                        toSubject:_clock keyPath:@"timeIntervalSince1970"
               withValueTransform:^(id value) { return [value stringValue]; }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_bindingManager enable];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_bindingManager disable];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [_bindingManager removeAllBindings];
    _bindingManager = nil;
    
    [self setHoursLabel:nil];
    [self setMinutesLabel:nil];
    [self setSecondsLabel:nil];
    [self setIntervalLabel:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [_clock stop];
    
    [_bindingManager removeAllBindings];
    
}

@end
