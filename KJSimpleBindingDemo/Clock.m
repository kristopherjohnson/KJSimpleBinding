//
//  Clock.m
//  KJSimpleBinding
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

#import "Clock.h"

@implementation Clock

@synthesize hours = _hours;
@synthesize minutes = _minutes;
@synthesize seconds = _seconds;
@synthesize timeIntervalSince1970 = _timeIntervalSince1970;

- (id)init {
    self = [super init];
    if (self) {
        self.hours = @"";
        self.minutes = @"";
        self.seconds = @"";
    }
    return self;
}


- (void)tick {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:now];
    
    // Update properties. (KVO observers will get notified of these changes.)
    self.timeIntervalSince1970 = [now timeIntervalSince1970];
    self.hours = [NSString stringWithFormat:@"%02d", (int)[dateComponents hour]];
    self.minutes = [NSString stringWithFormat:@"%02d", (int)[dateComponents minute]];
    self.seconds = [NSString stringWithFormat:@"%02d", (int)[dateComponents second]];
    
    // Set up timer to do this again
    if (_isStarted) {
        double delayInSeconds = 0.1;
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
