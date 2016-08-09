//
//  SampleProtocol.h
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
// Protocol definition starts here
@protocol SampleProtocolDelegate <NSObject>
@required
- (void) processCompleted;
@end
// Protocol Definition ends here

@interface SampleProtocol : NSObject
{
    // Delegate to respond back
    id <SampleProtocolDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

-(void)startSampleProcess; // Instance method

@end
