//
//  StoryLoader.h
//  TN
//
//  Created by Guillermo Frias on 24/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopNewsViewController.h"

@interface StoryLoader : NSObject
- (void) loadTopStories:(TopNewsViewController*) topNewsViewController from:(int)from until:(int)until;
@end
