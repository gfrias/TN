//
//  TopNewsViewController.h
//  TN
//
//  Created by Guillermo Frias on 23/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface TopNewsViewController : UITableViewController

-(void) receive:(Story*)story atIndex:(NSUInteger)index;


@end
