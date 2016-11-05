//
//  Utilities.m
//
//
//  Created by on 10/14/16.
//  Copyright © 2016 . All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


+ (NSString *)timeStampWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
    });
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    return timeStamp;
}

+ (UIImage *)resizedImageFromImage:(UIImage *)image
{
    CGFloat largestSide = image.size.width > image.size.height ? image.size.width : image.size.height;
    CGFloat scaleCoefficient = largestSide / 560.0f;
    CGSize newSize = CGSizeMake(image.size.width / scaleCoefficient, image.size.height / scaleCoefficient);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:(CGRect){0, 0, newSize.width, newSize.height}];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
+ (float)getWidthofString:(NSString*)text
                forFont:(UIFont*)font{
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName: font}];
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize.width;
}
+ (UIColor*)getRandomColor{
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    NSLog(@"%@", color);
    return color;
}
+(NSString*)getFileName:(NSString*)parentFolderName withExtension:(NSString*)fileExtension{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [dirPaths objectAtIndex:0];
    NSString *timeStamp=[Utilities getTimeStamp];
    NSString *fileName=@"";
    if (parentFolderName) {
        fileName = [NSString stringWithFormat:@"%@/%@/%@%@",
                    documentsDirectory,parentFolderName,timeStamp,fileExtension];
    }
    else{
        fileName = [NSString stringWithFormat:@"%@/%@%@",
                    documentsDirectory,timeStamp,fileExtension];
    }
    return fileName;
}
+(NSString*)getTimeStamp{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMddHHMMSS"];
    NSString* timeStamp = [formatter stringFromDate:date];
    return timeStamp;
}
@end
