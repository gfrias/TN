//
//  TNNavigationController.m
//  TN
//
//  Created by Guillermo Frias on 25/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "TNNavigationController.h"

@interface TNNavigationController ()

@end

@implementation TNNavigationController

// in UINavigationController subclass
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.view addSubview:progress];
    UINavigationBar *navBar = [self navigationBar];

    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:progress attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:-0.5];
    [self.view addConstraint:constraint];

    constraint = [NSLayoutConstraint constraintWithItem:progress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:constraint];

    constraint = [NSLayoutConstraint constraintWithItem:progress attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:constraint];

    [progress setTranslatesAutoresizingMaskIntoConstraints:NO];
    progress.hidden = YES;
    progress.tintColor = [UIColor blackColor];
    
    self.progressView = progress;
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
