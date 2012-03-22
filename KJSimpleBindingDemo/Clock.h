//
//  Clock.h
//  KJSimpleBinding
//
//  Created by Kristopher Johnson on 3/21/12.
//  Copyright (c) 2012 Capable Hands Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clock : NSObject {
@private
    BOOL _isStarted;
}

@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *minutes;
@property (nonatomic, copy) NSString *seconds;

- (void)start;

- (void)stop;

@end
