//
//  EffectsViewController.m
//  Refresher-OBJC
//
//  Created by on 11/1/16.
//  Copyright © 2016 Inc. All rights reserved.
//
/*
 References:
 http://stackoverflow.com/questions/4431292/inner-shadow-effect-on-uiview-layer
 https://nachbaur.com/2010/11/16/fun-shadow-effects-using-custom-calayer-shadowpaths/
 http://stackoverflow.com/questions/10133109/fastest-way-to-do-shadows-on-ios
 http://www.innofied.com/implementing-shadow-ios/
 http://blog.app-it.dk/blog/2013/12/17/uiview-with-shadow-and-rounded-corners
 http://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow/12969741
 */

#import "EffectsViewController.h"
#import "RippleEffect.h"

#define ORIGIN_X            50
#define IMAGE_VIEW_MARGIN   60
#define IMAGE_VIEW_WIDTH    208
#define IMAGE_VIEW_HEIGHT   208

@interface EffectsViewController ()
@property (nonatomic,strong) UIScrollView* scroller;
@property (assign) int imageViewCount;
@end

@implementation EffectsViewController

#pragma marks View Life Cycle Handling

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageViewCount = 0;
    [self createScroller];
    [self configureGesture];
    [self createShadowWithBGImage];
    [self createRectangularShadow];
    [self createOverallShadow];
    [self createTrapezoidalShadow];
    [self createEllipticalShadow];
    [self createPaperCurlShadow];
    [self createCircularShadow];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Compute the content size of the scroller once all the subviews are added to it.
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scroller.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scroller.contentSize = contentRect.size;
}

#pragma marks Private methods

- (void) createScroller{
    self.scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scroller.showsHorizontalScrollIndicator=YES;
    [self.view addSubview:self.scroller];
}

- (void)configureGesture{
    // Single tap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRipple)];
    singleTap.numberOfTapsRequired = 1;
    [self.scroller addGestureRecognizer:singleTap];
}

- (void) showRipple{
    CGPoint center = CGPointMake(self.scroller.bounds.size.width / 2,self.scroller.bounds.size.height / 2);
    [RippleEffect rippleWithView:self.scroller center:center colorFrom:[UIColor  purpleColor] colorTo:[UIColor  purpleColor]];
}

- (void) createShadowWithBGImage{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Inner Shadow with BG Image" andLayer:NO];
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"innerShadow2.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(5.0f/21.0f, 5.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = imageView.bounds;
    [imageView.layer addSublayer:innerShadowLayer];
    [self.scroller addSubview:imageView];
}
- (void)createRectangularShadow{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Rectangular Shadow" andLayer:YES];
    // To improve performance
    // This set the inside of the path opaque.
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.bounds];
    imageView.layer.shadowPath = path.CGPath;
    [self.scroller addSubview:imageView];
}

- (void)createOverallShadow{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Overall Shadow" andLayer:YES];
    //applying overall shadow to image
    imageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    imageView.layer.shadowRadius = 6.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.bounds];
    imageView.layer.shadowPath = path.CGPath;
    [self.scroller addSubview:imageView];
}
- (void)createTrapezoidalShadow{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Trapezoidal Shadow" andLayer:YES];
    CGSize size = imageView.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width * 0.33f, size.height * 0.66f)];
    [path addLineToPoint:CGPointMake(size.width * 0.66f, size.height * 0.66f)];
    [path addLineToPoint:CGPointMake(size.width * 1.15f, size.height * 1.15f)];
    [path addLineToPoint:CGPointMake(size.width * -0.15f, size.height * 1.15f)];
    imageView.layer.shadowPath = path.CGPath;
    [self.scroller addSubview:imageView];
}
- (void)createEllipticalShadow{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Elliptical Shadow" andLayer:YES];
    CGSize size = imageView.bounds.size;
    CGRect ovalRect = CGRectMake(0.0f, size.height + 5, size.width - 10, 15);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    imageView.layer.shadowPath = path.CGPath;
    [self.scroller addSubview:imageView];
}
- (void)createPaperCurlShadow{
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Paper Curl Shadow" andLayer:YES];
    CGSize size = imageView.bounds.size;
    CGFloat curlFactor = 15.0f;
    CGFloat shadowDepth = 5.0f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    imageView.layer.shadowPath = path.CGPath;
    [self.scroller addSubview:imageView];
}

- (void)createCircularShadow{
    // 1. Create a shadow view first as a container
    UIView *shadow = [[UIView alloc]init];
    shadow.layer.cornerRadius = 5.0;
    shadow.layer.shadowColor = [[UIColor blackColor] CGColor];
    shadow.layer.shadowOpacity = 1.0;
    shadow.layer.shadowRadius = 10.0;
    shadow.layer.shadowOffset = CGSizeMake(0.0f, -0.5f);
    // 2. Create imageview and then add it to container view
    UIImageView* imageView = [self createImageViewWithImageName:@"ring_2" description:@"Circular" andLayer:NO];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
    [shadow addSubview:imageView];
    // 3. Insert a transperant view in order to make calculation of scroller content size correct.
    UIView* baseView = [[UIView alloc]initWithFrame:imageView.frame];
    baseView.backgroundColor = [UIColor clearColor];
    [self.scroller addSubview: shadow];
    [self.scroller insertSubview:baseView aboveSubview:shadow];
    

}

- (UIImageView*)createImageViewWithImageName:(NSString*)imageName description:(NSString*)description andLayer:(BOOL)isLayerEnabled{
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    int originY =self.navigationController.toolbar.frame.size.height+ (IMAGE_VIEW_HEIGHT+ IMAGE_VIEW_MARGIN) * self.imageViewCount;
    imageView.frame = CGRectMake(ORIGIN_X, originY, IMAGE_VIEW_WIDTH, IMAGE_VIEW_HEIGHT);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Add description
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -10, 300, 40)];
    [aLabel setText:description];
    [imageView addSubview:aLabel];
    self.imageViewCount++;
    if (isLayerEnabled) {
        // Basic layer manipulation
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOpacity = 0.7f;
        imageView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
        imageView.layer.shadowRadius = 5.0f;
        imageView.layer.masksToBounds = NO;
    }
    // Performance optimization : Rasterization
    // On default a CALayer draws a shadow during animations, the following code allows you to cache the shadow as a bitmap and reuse it instead of redrawing it
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return imageView;
}
@end
