//
//  Story.m
//  TN
//
//  Created by Guillermo Frias on 23/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "Story.h"

@implementation Story

@synthesize title = _title;
@synthesize url = _url;
@synthesize by = _by;
@synthesize score = _score;
@synthesize comments = _comments;

- (Story*) initWithTitle: (NSString*) title andUrl:(NSString*) url byAuthor:(NSString*)by withScore:(NSNumber*) score
             andComments:(NSNumber*) comments {
    self.title = title;
    self.url = url;
    self.by = by;
    self.score = score;
    self.comments = comments;

    return self;
}
@end
