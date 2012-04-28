//
//  KJBindingManagerTests.m
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

#import "KJBindingManagerTests.h"
#import "KJBindingManager.h"

// TestModel is a simple KVC/KVO-compliant object
@interface TestModel : NSObject
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSString *stringValue2;
@property (nonatomic) NSInteger numericValue;
@property (nonatomic) TestModel *submodel;
@end

@implementation TestModel

@synthesize stringValue;
@synthesize stringValue2;
@synthesize numericValue;
@synthesize submodel;


@end

// TestObserver is a simple KVC/KVO-compliant object
@interface TestObserver : NSObject
@property (nonatomic, copy) NSString *text;
@end

@implementation TestObserver

@synthesize text;


@end


@implementation KJBindingManagerTests

- (void)setUp {
    bindingManager = [[KJBindingManager alloc] init];
}

- (void)tearDown {
    [bindingManager disable];
    bindingManager = nil;
}

- (void)testCopiesValuesOnEnable {
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"Test Value";
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    STAssertNil(observer.text, @"Value should not change until activation");
    
    [bindingManager enable];
    
    STAssertTrue([bindingManager isEnabled], nil);
    
    STAssertEqualObjects(@"Test Value", observer.text,
                         @"Value should have been copied from model to observer");
}

- (void)testCopiesValuesOnChange {
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"Test Value";
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    [bindingManager enable];
    
    model.stringValue = @"Changed Value";
    
    STAssertEqualObjects(@"Changed Value", observer.text,
                         @"New value should have been copied from model to observer");
    
    model.stringValue = @"Changed Value Again";
    
    STAssertEqualObjects(@"Changed Value Again", observer.text,
                         @"Newer value should have been copied from model to observer");
}

- (void)testDoesNotCopyAfterDeactivate {
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"Test Value";
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    STAssertNil(observer.text, @"Value should not change until activation");
    
    [bindingManager enable];
    
    model.stringValue = @"First Value";
    
    STAssertEqualObjects(@"First Value", observer.text,
                         @"New value should have been copied from model to observer");
    
    [bindingManager disable];
    
    STAssertFalse([bindingManager isEnabled], nil);
    
    model.stringValue = @"Second Value";
    
    STAssertEqualObjects(@"First Value", observer.text,
                         @"Value should not have been copied after -deactivateBindings");
    
}

- (void)testAddBindingToEnabledBindingManager {
    
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"Test Value";
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager enable];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    STAssertEqualObjects(@"Test Value", observer.text, @"Value should change immediately");
    
    model.stringValue = @"First Value";
    
    STAssertEqualObjects(@"First Value", observer.text,
                         @"New value should have been copied from model to observer");
}

- (void)testRemoveBindings {
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"Test Value";
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    [bindingManager enable];
    
    model.stringValue = @"Changed Value";

    [bindingManager removeAllBindings];
    
    model.stringValue = @"Changed Value Again";
    
    STAssertEqualObjects(@"Changed Value", observer.text,
                         @"Newer value should not have been copied after bindings removed");
    
    STAssertTrue([bindingManager isEnabled], @"Should still be enabled");
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model    keyPath:@"stringValue"];
    
    STAssertEqualObjects(@"Changed Value Again", observer.text,
                         @"Newer value should have been copied after re-bind");
}

- (void)testMultipleModelProperties {
    TestModel *model = [[TestModel alloc] init];
    model.stringValue = @"String 1";
    model.stringValue2 = @"String 2";
    
    TestObserver *observer1 = [[TestObserver alloc] init];
    TestObserver *observer2 = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer1 keyPath:@"text"
                       toSubject:model     keyPath:@"stringValue"];
    [bindingManager bindObserver:observer2 keyPath:@"text"
                       toSubject:model     keyPath:@"stringValue2"];
    
    [bindingManager enable];
    
    STAssertEqualObjects(@"String 1", observer1.text, nil);
    STAssertEqualObjects(@"String 2", observer2.text, nil);
    
    model.stringValue = @"Changed String 1";
    model.stringValue2 = @"Changed String 2";
    
    STAssertEqualObjects(@"Changed String 1", observer1.text, nil);
    STAssertEqualObjects(@"Changed String 2", observer2.text, nil);
}

- (void)testMultipleModels {
    TestModel *model1 = [[TestModel alloc] init];
    model1.stringValue = @"String 1";
    
    TestModel *model2 = [[TestModel alloc] init];
    model2.stringValue = @"String 2";
    
    TestObserver *observer1 = [[TestObserver alloc] init];
    TestObserver *observer2 = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer1 keyPath:@"text"
                       toSubject:model1    keyPath:@"stringValue"];
    [bindingManager bindObserver:observer2 keyPath:@"text"
                       toSubject:model2    keyPath:@"stringValue"];
    
    [bindingManager enable];
    
    STAssertEqualObjects(@"String 1", observer1.text, nil);
    STAssertEqualObjects(@"String 2", observer2.text, nil);
    
    model1.stringValue = @"Changed String 1";
    model2.stringValue = @"Changed String 2";
    
    STAssertEqualObjects(@"Changed String 1", observer1.text, nil);
    STAssertEqualObjects(@"Changed String 2", observer2.text, nil);    
}

- (void)testValueTransform {
    TestModel *model = [[TestModel alloc] init];
    model.numericValue = 33;
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:model keyPath:@"numericValue"
              withValueTransform:^(id value) { return [value stringValue]; }];
    
    [bindingManager enable];
    
    STAssertEqualObjects(@"33", observer.text, nil);
    
    model.numericValue = 22;
    STAssertEqualObjects(@"22", observer.text, nil);
}

- (void)testSubjectKeyPath {
    TestModel *topModel = [[TestModel alloc] init];
    TestModel *subModel = [[TestModel alloc] init];
    
    topModel.submodel = subModel;
    
    TestObserver *observer = [[TestObserver alloc] init];
    
    // Bind to topModel, but use a key path to actually bind to its submodel's stringValue
    [bindingManager bindObserver:observer keyPath:@"text"
                       toSubject:topModel keyPath:@"submodel.stringValue"];
    [bindingManager enable];
    
    subModel.stringValue = @"Submodel value";
    
    STAssertEqualObjects(@"Submodel value", observer.text, nil);
}

@end
