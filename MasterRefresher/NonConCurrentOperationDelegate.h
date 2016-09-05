//
//  NonConCurrentOperationDelegate.h
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NonConCurrentOperationDelegate <NSObject>
- (void)didFinishLoad:(NSDictionary *)info;
@end
