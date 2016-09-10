//
//  NewsViewController.m
//  TN
//
//  Created by Guillermo Frias on 04/09/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "TNNavigationController.h"
#import "NewsViewController.h"

@interface NewsViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NewsViewController
@synthesize url = _url;

- (void)viewDidLoad {
    [super viewDidLoad];
    TNNavigationController *tnc = (TNNavigationController*)self.navigationController;
    self.progressView = tnc.progressView;

    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.webView.delegate = self;

    [self beginProgress];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.webView loadRequest:requestObj];

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self hideProgress:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) progressLoading: (NSTimer*) timer {
    if (self.progressView.progress < 0.8) {
        self.progressView.progress += .05;
    } else if (self.progressView.progress == 1){

        [self.timer invalidate];
        [NSTimer scheduledTimerWithTimeInterval:0.3
                                         target:self
                                       selector:@selector(hideProgress:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)beginProgress {
    self.progressView.progress = 0;
    self.progressView.hidden = NO;

    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(progressLoading:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)hideProgress:(NSTimer*) timer {
    [timer invalidate];
    self.progressView.hidden = YES;
}

-(void)endProgress {
    self.progressView.progress = 1;
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self endProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self endProgress];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
