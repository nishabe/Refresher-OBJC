//
//  Student.m
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "Student.h"

@implementation Student
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.age = 0;
    }
    return self;
}
@end
