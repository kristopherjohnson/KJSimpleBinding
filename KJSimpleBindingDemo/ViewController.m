//
//  ViewController.m
//  KJSimpleBindingDemo
//
//  Created by Kristopher Johnson on 3/21/12.
//  Copyright (c) 2012 Capable Hands Technologies, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize hoursLabel;
@synthesize minutesLabel;
@synthesize secondsLabel;

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
    [_bindingManager release];
    _bindingManager = nil;
    
    [self setHoursLabel:nil];
    [self setMinutesLabel:nil];
    [self setSecondsLabel:nil];

    [super viewDidUnload];
}

- (void)dealloc {
    [_clock stop];
    [_clock release];
    
    [_bindingManager release];
    
    [hoursLabel release];
    [minutesLabel release];
    [secondsLabel release];
    
    [super dealloc];
}

@end
