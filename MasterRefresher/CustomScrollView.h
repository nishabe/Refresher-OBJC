//
//  CustomScrollView.h
//  Refresher-OBJC
//
//  Created by   on 10/20/16.
//  Copyright © 2016   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomViewTapDelegate <NSObject>
@optional
- (void)didTapOnSuggestionButton:(id)sender;
@end

@interface CustomScrollView : UIView
@property(retain,nonatomic) NSArray* buttonLabels;
@property (weak, nonatomic) id<CustomViewTapDelegate> delegate;

-(void)configureView;

@end
