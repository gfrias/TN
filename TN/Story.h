//
//  Story.h
//  TN
//
//  Created by Guillermo Frias on 23/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* url;
@property(strong, nonatomic) NSString* by;
@property(strong, nonatomic) NSNumber* score;
@property(strong, nonatomic) NSNumber* comments;

- (Story*) initWithTitle: (NSString*) title andUrl:(NSString*) url byAuthor:(NSString*)by withScore:(NSNumber*) score
             andComments:(NSNumber*) comments;

@end
