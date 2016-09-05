//
//  OperationQueueViewController.m
//  Refresher-OBJC
//
//  Created by       on 9/1/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import "OperationQueueViewController.h"
#import "RefresherConstants.h"

@interface OperationQueueViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (NSArray *)urlFixtures;

@end
@implementation OperationQueueViewController

# pragma mark - NSInvocation Operation

-(void)sayHello{
    NSLog(@"Hey! How are you?");
}

- (IBAction)didTapOnInvocationOperationButton:(id)sender {
    /*
     If you just want to pass a message to an object, you can use NSInvocationOperation
     Use this if you have the objects and methods already, needed to perform the necessary tasks.You can also use it when the method you want to call can change depending on the circumstances. For example, you could use an invocation operation to perform a selector that is chosen dynamically based on user input.
     */
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello) object:nil];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:invocationOperation];
}

# pragma mark - NSBlockOperation Operation

- (IBAction)didTapOnBlockOperationButton:(id)sender {
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    // You can have as many NSBlockOperations here
    NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"The block operation ended, Do something such as show a successmessage etc");
        //This the completion block operation
    }];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        //This is the worker block operation
        [self sayHello];
    }];
    // Adding dependency
    [blockCompletionOperation addDependency:blockOperation];
    [operationQueue addOperation:blockCompletionOperation];
    [operationQueue addOperation:blockOperation];
}

# pragma mark - AddOperationWithBlock Operation

- (IBAction)didTapOnAddOperationWithBlock:(id)sender {
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        // Background work
        [self sayHello];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Main thread work (UI usually)
        }];
    }];
}

# pragma mark - Non asyncronous Operation

- (IBAction)didTapOnNonAsyncButton:(id)sender {
    /*
    
     */
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // The maximum number of queued operations that can execute at the same time.
    [queue setMaxConcurrentOperationCount:3];
    
    for(NSURL *url in [self urlFixtures]) {
        NonConCurrentOperation *operation = [[NonConCurrentOperation alloc]initWithRootURL:url];
        operation.delegate = self;
        [queue addOperation:operation];
    }
}

- (NSArray *)urlFixtures
{
    return [NSArray arrayWithObjects:
            [NSURL URLWithString:SAMPLE_IMAGE_URL1],
            [NSURL URLWithString:SAMPLE_IMAGE_URL2],
            [NSURL URLWithString:SAMPLE_IMAGE_URL3],
            [NSURL URLWithString:SAMPLE_IMAGE_URL4],nil];
}

# pragma mark - Asyncronous Operation


- (IBAction)didTapOnAsyncButton:(id)sender {
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    for(NSURL *url in [self urlFixtures]) {
        ConcurrentOperation *operation = [[ConcurrentOperation alloc]initWithRootURL:url];
        operation.delegate = self;
        [queue addOperation:operation];
    }
}

# pragma mark - delegate methods

- (void)didFinishLoad:(NSDictionary *)info
{
    NSLog(@"image downloaded");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = [info valueForKey:@"image"];
    }];
}
@end
