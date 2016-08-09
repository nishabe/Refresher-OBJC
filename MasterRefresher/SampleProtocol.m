//
//  SampleProtocol.m
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "SampleProtocol.h"


@implementation SampleProtocol

-(void)startSampleProcess{
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                   selector:@selector(callDelegate) userInfo:nil repeats:NO];
}
-(void)callDelegate{
    if ([self.delegate conformsToProtocol:@protocol(SampleProtocolDelegate)]) {
        [self.delegate processCompleted];
    }
}
@end
