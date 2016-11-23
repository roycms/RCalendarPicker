//
//  RCalendarPickerTests.m
//  RCalendarPickerTests
//
//  Created by roycms on 2016/11/16.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateHelper.h"
@interface RCalendarPickerTests : XCTestCase

@end

@implementation RCalendarPickerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertEqual((int)[DateHelper day:[NSDate date]],21, @"ok ");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
