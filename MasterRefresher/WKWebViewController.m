//
//  MKWebViewController.m
//  Refresher-OBJC
//
/*
Reference:
 http://www.appcoda.com/webkit-framework-intro/
*/
#import "WKWebViewController.h"
#define URL_1 @"https://www.google.com/#q=2016"
#define URL_2 @"http://www.appcoda.com"

@interface WKWebViewController ()
@property(strong,nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation WKWebViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadPrimaryPageHTML];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPrimaryPageHTML{

    NSURLRequest *requestObject = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_2]];
    [self.webView loadRequest:requestObject];
    _webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.navigationDelegate = self;
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    [self.progressView setProgress:0.0];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            if (self.webView.estimatedProgress==1) {
                self.progressView.hidden=YES;
            }else{
                [self.progressView setProgress:self.webView.estimatedProgress];
            }
        }
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKWebView Loading & Delegate Handling

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"Started loading");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"Load Error:%@",error);}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"Et:progress->%f",webView.estimatedProgress);
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"Load Error:%@",error);}
@end
