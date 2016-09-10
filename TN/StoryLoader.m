//
//  StoryLoader.m
//  TN
//
//  Created by Guillermo Frias on 24/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "StoryLoader.h"
#import "Story.h"
#import "TopNewsViewController.h"

@implementation StoryLoader

#pragma mark - Load Data Utils

- (void)loadData:(NSString*)dataUrl withCompletionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response,
                                                                    NSError * __nullable error))completionHandler {
    NSURL *url = [NSURL URLWithString:dataUrl];

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:completionHandler];

    [downloadTask resume];

}

- (void) loadTopStories:(TopNewsViewController*) topNewsViewController from:(int)from until:(int)until {
    NSString *url = @"https://hacker-news.firebaseio.com/v0/topstories.json";
    [self loadData:url withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *e = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];

        NSUInteger count = 0;
        for (int i = from; i < until; i++){
            NSNumber *item = (NSNumber*)[jsonArray objectAtIndex:i];
            if (count < until) {
                [self loadItem: item onTopNewsViewController: topNewsViewController atIndex:i];
            }
            count++;
        }
    }];
}

- (void) loadItem: (NSNumber*) item onTopNewsViewController:(TopNewsViewController*) topNewsViewController atIndex:(NSUInteger) index {
    NSString *url = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@.json", [item stringValue]];

    [self loadData:url withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *e = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        Story *story = [self parseStory:dictionary];

        [topNewsViewController receive:story atIndex:index];
    }];
}

- (Story*) parseStory:(NSDictionary*)dictionary {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    Story *story = [[Story alloc] initWithTitle:[[dictionary valueForKey:@"title"] description]
                                         andUrl:[[dictionary valueForKey:@"url"] description]
                                       byAuthor:[[dictionary valueForKey:@"by"] description]
                                      withScore:[f numberFromString:[[dictionary valueForKey:@"score"] description]]
                                    andComments:[f numberFromString:[[dictionary valueForKey:@"descendants"] description]]
                    ];

    return story;
}


@end
