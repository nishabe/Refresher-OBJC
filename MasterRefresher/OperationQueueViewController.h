//
//  OperationQueueViewController.h
//  Refresher-OBJC
//
//  Created by       on 9/1/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NonConCurrentOperation.h"
#import "ConcurrentOperation.h"

@interface OperationQueueViewController : UIViewController <NonConCurrentOperationDelegate>

@end
