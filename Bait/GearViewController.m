//
//  GearViewController.m
//  Bait
//
//  Created by Stephen Blair on 8/17/15.
//  Copyright (c) 2015 Stephen Blair. All rights reserved.
//

#import "GearViewController.h"

@interface GearViewController ()

@property (nonatomic, strong) WKWebView *gearWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation GearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeRevealView];
    [self initializeNavigationImage];
//    [self loadWebView];
    
    self.gearWebView = [[WKWebView alloc] init];
    self.gearWebView.navigationDelegate = self;
    
//    @"http://www.baitapp.squarespace.com"
    NSString *urlString = @"http://www.baitapp.squarespace.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.gearWebView loadRequest:request];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    [self.view addSubview:self.gearWebView];
}

-(void)loadWebView{
    self.gearWebView = [[WKWebView alloc] init];
    self.gearWebView.navigationDelegate = self;
    
    NSString *urlString = @"http://www.baitapp.squarespace.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.gearWebView loadRequest:request];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    [self.view addSubview:self.gearWebView];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.gearWebView.frame = self.view.frame;
}

-(void) initializeRevealView{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void) initializeNavigationImage{
    UIImage *fishHookImage = [UIImage imageNamed:@"baitText.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fishHookImage];
    self.navigationItem.titleView = imageView;
}

#pragma mark - WKNavigation Delegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.activityIndicator stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    [self webView:self.gearWebView didFailNavigation:navigation withError:error];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"FAILED TO LOAD");
    if (error.code != NSURLErrorCancelled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
