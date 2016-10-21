//
//  CustomScrollView.m
//  Refresher-OBJC
//
//  Created by   on 10/20/16.
//  Copyright © 2016   . All rights reserved.
//

#import "CustomScrollView.h"

#define BUTTON_FRAME_MARGIN 5
#define BUTTON_FRAME_WIDTH  125
#define BUTTON_FRAME_HEIGHT 30
#define BUTTON_FONT_SIZE 18.0

@interface CustomScrollView()
@property(nonatomic,retain) UIScrollView *scrollView;
@end
@implementation CustomScrollView

-(void)configureView{
    
    // 1. Configure the scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=YES;
    
    // 2. Create buttons and set the frames in runtime
    int lastOrigin = 0;
    for (NSString * label in self.buttonLabels) {
        if (label.length>0) {
            UIButton* aButton = [self createButtonithTitle:label];
            float aButtonWidth = [self getWidthofString:label forFont:[UIFont systemFontOfSize:BUTTON_FONT_SIZE]] + BUTTON_FRAME_MARGIN * 2;
            aButton.frame = CGRectMake(BUTTON_FRAME_MARGIN + lastOrigin, 5, aButtonWidth, BUTTON_FRAME_HEIGHT);
            [self.scrollView addSubview:aButton];
            lastOrigin = lastOrigin + aButton.frame.size.width+ BUTTON_FRAME_MARGIN;
        }
    }
    
    // 3. Set the contextSize of the scrollview in run time based on the width of added buttons
    self.scrollView.contentSize = CGSizeMake([self getScrollContextWidth], self.frame.size.height);
    CGRect contentRect = CGRectZero;
    for (UIButton *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.scrollView];
}

- (UIButton*) createButtonithTitle:(NSString*)title {
    UIButton *aButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    aButton.frame = CGRectZero;
    [aButton setTitle:title forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
    [aButton addTarget:self action:@selector(didTapOnsuggestionButton:) forControlEvents:UIControlEventTouchUpInside];
    aButton.layer.cornerRadius = 10;
    aButton.layer.borderWidth = 1;
    aButton.clipsToBounds = YES;
    aButton.backgroundColor = [UIColor whiteColor];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return aButton;
}

- (float)getWidthofString:(NSString*)text
                  forFont:(UIFont*)font{
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName: font}];
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize.width;
}

- (float)getScrollContextWidth{
    float width = 0.0;
    for (UIView * subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            width = width + subView.frame.size.width;
        }
    }
    // MARGIN + MARGIN * LABELS COUNT + SUM OF WIDTH OF ALL LABELS
    return BUTTON_FRAME_MARGIN + BUTTON_FRAME_MARGIN* self.buttonLabels.count+ width;
}

- (void) didTapOnsuggestionButton:(id)sender{
    [self.delegate didTapOnSuggestionButton:sender];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake([self getScrollContextWidth], self.frame.size.height);
    CGRect contentRect = CGRectZero;
    for (UIImageView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    
}
@end
