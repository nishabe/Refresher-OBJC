//
//  IntrospectionViewController.m
//  Refresher-OBJC
//
//  Created by      on 8/25/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>

#import "IntrospectionViewController.h"
#import "SecretMission.h"


@implementation IntrospectionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self introspectionTests];
}
-(void)introspectionTests{
    SecretMission *mission =  [[SecretMission alloc] init];
    // Option 1.
    Class currentClass = [self class];
    Class missionClass = [mission class];
    Class superClass = [mission superclass];
    NSLog(@"Current class %@, Sample class is %@, and super is %@.",currentClass,missionClass,superClass);
    // Option 2.
    Class anotherSuperClass = class_getSuperclass(missionClass);
    NSLog(@"Superclass of %@ is %@",NSStringFromClass(missionClass),NSStringFromClass(anotherSuperClass));
    // Selectors
    SEL selector = @selector(testMethod);
    NSLog(@"Selector: %@", NSStringFromSelector(selector));
    
    Method method = class_getInstanceMethod(currentClass, selector);
    NSLog(@"%d arguments", method_getNumberOfArguments(method));
    
    NSLog(@"Memeber of NSObect - %d",[mission isMemberOfClass:[NSObject class]]);
    NSLog(@"Kind of NSObect - %d",[mission isKindOfClass:[NSObject class]]);
    
    if ([mission respondsToSelector:@selector(testMethod)]) {
        [mission performSelector:@selector(testMethod) withObject:nil];
        NSLog(@"Reponds!");
    }
    // Version 1: Simple objc_msgSend example
    
    //NSString* hisName = objc_msgSend(mission, @selector(testMethodTwo));
    // To make this work, you need to turn off -> "Enable Strict checking for objc_msgCalls" setting under "Preprocessing"
    
    // Version 2: More complicated objc_msgSend example
    
    //NSString* hisName = ((id (*)(id, SEL))objc_msgSend)(mission, @selector(testMethodTwo));

}
-(void)testMethod{
    NSLog(@"Testing over!");
}
@end
