//
//  Clock.m
//  KJSimpleBinding
//
//  Created by Kristopher Johnson on 3/21/12.
//  Copyright (c) 2012 Capable Hands Technologies, Inc. All rights reserved.
//

#import "Clock.h"

@implementation Clock

@synthesize hours = _hours;
@synthesize minutes = _minutes;
@synthesize seconds = _seconds;

- (id)init {
    self = [super init];
    if (self) {
        self.hours = @"";
        self.minutes = @"";
        self.seconds = @"";
    }
    return self;
}

- (void)dealloc {
    [_hours release];
    [_minutes release];
    [_seconds release];
    [super dealloc];
}

- (void)tick {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:now];
    
    // Update properties. (KVO observers will get notified of these changes.)
    self.hours = [NSString stringWithFormat:@"%02d", (int)[dateComponents hour]];
    self.minutes = [NSString stringWithFormat:@"%02d", (int)[dateComponents minute]];
    self.seconds = [NSString stringWithFormat:@"%02d", (int)[dateComponents second]];
    
    // Set up timer to do this again
    if (_isStarted) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self tick];
        });
    }
}

- (void)start {
    _isStarted = YES;
    [self tick];
}

- (void)stop {
    _isStarted = NO;
}


@end
