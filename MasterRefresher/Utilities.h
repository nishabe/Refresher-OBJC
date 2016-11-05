//
//  Utilities.h
//  Utilities
//
//  Created by   on 10/14/16.
//  Copyright © 2016  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject
+ (UIImage *)resizedImageFromImage:(UIImage *)image;
+ (NSString *)timeStampWithDate:(NSDate *)date;
+ (float)getWidthofString:(NSString*)text
                forFont:(UIFont*)font;
+ (UIColor*)getRandomColor;
+(NSString*)getFileName:(NSString*)parentFolderName withExtension:(NSString*)fileExtension;
+(NSString*)getTimeStamp;
@end
