
//
//  BlockWebserviceViewController.m
//  Refresher-OBJC
//
//  Created by on 8/25/16.
//  Copyright © 2016 Inc. All rights reserved.
//

#import "BlockWebserviceViewController.h"
@interface BlockWebserviceViewController()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation BlockWebserviceViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    // Web service call
    [self fetchData];
    [self fetchDataUsingSession];
}
-(void)fetchData{
    NSURL *url = [NSURL URLWithString:@"http://rest-service.guides.spring.io/greeting"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
// Below is an example to suppress a compiler warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // NSURLConnection sendAsynchronousRequest is depracted. Added below just for reference purpose. Suggested to use NSURLSession.
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             self.idLabel.text = [[greeting objectForKey:@"id"] stringValue];
             self.contentLabel.text = [greeting objectForKey:@"content"];
         }
     }];
#pragma clang diagnostic pop

}

-(void)fetchDataUsingSession{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"]
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
    }];
    [dataTask resume];
}
@end
