//
//  ParsingViewController.m
//  Refresher-OBJC
//
//  Created by on 11/11/16.
//  Copyright © 2016 Inc. All rights reserved.
// Ref: http://www.theappguruz.com/blog/xmlparsing-with-nsxmlparser-tutorial
// http://www.appcoda.com/pull-to-refresh-uitableview-empty/

#import "ParsingViewController.h"
#import "NetworkCommunication.h"

#define LOCAL_SERVER @"http://10.155.111.97:42001"

@interface ParsingViewController () <UITableViewDataSource,NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;
@end

@implementation ParsingViewController

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(startParsing)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark User Action

- (IBAction)didTapOnJSONCall:(id)sender {
    NetworkCommunication *communicationManger = [[NetworkCommunication alloc] initWithRootURL:[NSURL URLWithString:LOCAL_SERVER]];
    communicationManger.delegate = self;
    [communicationManger startWebServiceRequestTask];
}
- (IBAction)didTapOnXMLCall:(id)sender {
    [self startParsing];
}

#pragma mark Private Methods

- (void)startParsing
{
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss#sthash.TyhRD7Zy.dpuf"]];
    [xmlparser setDelegate:self];
    [xmlparser parse];
    if (self.marrXMLData.count != 0) {
        [self reloadData];
    }
}
- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    // End the refreshing
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl endRefreshing];
    }
}

#pragma mark <NSXMLParserDelegate>

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString:@"rss"]) {
        self.marrXMLData = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"item"]) {
        self.mdictXMLPart = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    if (!self.mstrXMLString) {
        self.mstrXMLString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [self.mstrXMLString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"title"]
        || [elementName isEqualToString:@"pubDate"]) {
        [self.mdictXMLPart setObject:self.mstrXMLString forKey:elementName];
    }
    if ([elementName isEqualToString:@"item"]) {
        [self.marrXMLData addObject:self.mdictXMLPart];
    }
    self.mstrXMLString = nil;
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.marrXMLData) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.marrXMLData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[[self.marrXMLData objectAtIndex:indexPath.row] valueForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.detailTextLabel.text = [[[self.marrXMLData objectAtIndex:indexPath.row] valueForKey:@"pubDate"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cell;
}

#pragma mark Network Communication Handling

- (void)didRecieveResponse:(NSDictionary *)info{
    NSData *data = [[NSData alloc] initWithData:[info valueForKey:@"data"]];
    NSDictionary *responses = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:NULL];
    NSLog(@"Response: %@",responses);
}
@end
