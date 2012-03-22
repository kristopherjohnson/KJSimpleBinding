//
//  ViewController.h
//  KJSimpleBindingDemo
//
//  Created by Kristopher Johnson on 3/21/12.
//  Copyright (c) 2012 Capable Hands Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJBindingManager.h"
#import "Clock.h"

@interface ViewController : UIViewController {
    KJBindingManager *_bindingManager;
    Clock *_clock;
}

@property (retain, nonatomic) IBOutlet UILabel *hoursLabel;

@property (retain, nonatomic) IBOutlet UILabel *minutesLabel;

@property (retain, nonatomic) IBOutlet UILabel *secondsLabel;

@end
