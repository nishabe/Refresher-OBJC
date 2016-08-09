//
//  ExtensionViewController.h
//  Refresher-OBJC
//
//  Created by Aneesh Abraham01 on 8/9/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
// 'announcement' variable declared as readonly property.
@property (readonly,nonatomic) NSString *announcement;
@end
