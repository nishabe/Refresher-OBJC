//
//  DBManager.h
//  Refresher-OBJC
//
//  Created by on 11/6/16.
//  Copyright © 2016 Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

- (void) saveData:(NSString*)name password:(NSString*)password andSelectedMonth:(NSString*)month;
- (void)findContact:(NSString*)keyword;
+(DBManager*)getSharedInstance;

@end
