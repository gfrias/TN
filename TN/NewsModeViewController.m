//
//  NewsModeViewController.m
//  TN
//
//  Created by Guillermo Frias on 04/09/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "NewsModeViewController.h"
#import "NewsViewController.h"

@interface NewsModeViewController ()

@end

@implementation NewsModeViewController

@synthesize storyTitle = _storyTitle;
@synthesize url = _url;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.storyTitle;
    [self addBrowserButton];

    NSArray *childViewControllers = self.childViewControllers;
    for (UIViewController *uvc in childViewControllers){
        if ([uvc isKindOfClass:[NewsViewController class]]){
            NewsViewController *nvc = (NewsViewController*) uvc;
            nvc.url = self.url;
        }
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

- (void) openInSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
}

-(void) addBrowserButton {
    UIButton *browserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *browserBtnImage = [UIImage imageNamed:@"Image"];

    [browserBtn setBackgroundImage:browserBtnImage forState:UIControlStateNormal];
    [browserBtn addTarget:self action:@selector(openInSafari:) forControlEvents:UIControlEventTouchUpInside];
    browserBtn.frame = CGRectMake(0, 0, 28, 28);

    UIView *browserButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    browserButtonView.bounds = CGRectOffset(browserButtonView.bounds, -8, 0);
    [browserButtonView addSubview:browserBtn];

    UIBarButtonItem *browserButton = [[UIBarButtonItem alloc] initWithCustomView:browserButtonView];
    self.navigationItem.rightBarButtonItem = browserButton;
}


@end
