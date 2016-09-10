//
//  StoryCell.h
//  TN
//
//  Created by Guillermo Frias on 24/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *url;
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (strong, nonatomic) IBOutlet UILabel *by;

@end
