//
//  TopNewsViewController.m
//  TN
//
//  Created by Guillermo Frias on 23/07/16.
//  Copyright © 2016 Guille Inc. All rights reserved.
//

#import "TNNavigationController.h"
#import "TopNewsViewController.h"
#import "NewsModeViewController.h"
#import "Story.h"
#import "StoryLoader.h"
#import "StoryCell.h"


@interface TopNewsViewController ()
@property (strong, nonatomic) StoryLoader *storyLoader;
@property (assign, nonatomic) int storiesLoaded;
@property (assign, nonatomic) int storiesToBeLoaded;

@property (strong, nonatomic) NSMutableArray *stories;
@property (strong, nonatomic) NSMutableArray *newStories;

@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation TopNewsViewController

@synthesize stories = _stories;
@synthesize storyLoader = _storyLoader;

const int MAX_STORIES = 20;

- (void)viewDidLoad {
    [super viewDidLoad];

    TNNavigationController *tnc = (TNNavigationController*)self.navigationController;
    self.progressView = tnc.progressView;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshStories)
                  forControlEvents:UIControlEventValueChanged];

    UITableView *tableView = (UITableView*)self.view;
    UINib *nib = [UINib nibWithNibName:@"StoryCell" bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:@"storyCell"];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    tableView.tableFooterView = spinner;

    self.storiesLoaded = 0;
    self.storiesToBeLoaded = MAX_STORIES;

    [self refreshStories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) refreshStories {
    self.storiesLoaded = 0;
    self.storiesToBeLoaded = MAX_STORIES;

    //self.stories = [[NSMutableArray alloc]init];
    self.newStories = [[NSMutableArray alloc]init];

    for (NSInteger i = 0; i < self.storiesToBeLoaded; i++){
        [self.newStories addObject:[NSNull null]];
    }

    self.progressView.hidden = YES;
    self.progressView.progress = 0;

    [self.storyLoader loadTopStories:self from:0 until:MAX_STORIES];
}

-(void) receive:(Story *)story atIndex:(NSUInteger)index {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.newStories setObject:story atIndexedSubscript:index];

        self.progressView.hidden = NO;
        self.progressView.progress = ((float)++self.storiesLoaded)/MAX_STORIES;

        if (self.storiesLoaded >= self.storiesToBeLoaded) {
            self.stories = self.newStories;
            [(UITableView*)self.view reloadData];

            self.progressView.hidden = YES;
            [self.refreshControl endRefreshing];
        }

    });

}

-(void) loadMoreStories:(NSInteger)until {
    if (self.storiesToBeLoaded >= until+1) return;

    self.storiesToBeLoaded = self.storiesLoaded + MAX_STORIES;
    self.newStories = [[NSMutableArray alloc]init];

    for (NSInteger i = 0; i < self.storiesLoaded; i++){
        [self.newStories addObject:[self.stories objectAtIndex:i]];
    }
    for (NSInteger i = self.storiesLoaded; i < self.storiesToBeLoaded; i++){
        [self.newStories addObject:[NSNull null]];
    }

    [(UIActivityIndicatorView*)self.tableView.tableFooterView startAnimating];

    [self.storyLoader loadTopStories:self from:self.storiesLoaded until:self.storiesToBeLoaded];
}

-(void) append:(Story *)story atIndex:(NSUInteger)index {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.newStories setObject:story atIndexedSubscript:index];

        if (self.storiesLoaded >= self.storiesToBeLoaded) {
            self.stories = self.newStories;
            [(UITableView*)self.view reloadData];
            [(UIActivityIndicatorView*)self.tableView.tableFooterView stopAnimating];
        }
    });
}



-(StoryLoader*) storyLoader {
    if (!_storyLoader){
        _storyLoader = [[StoryLoader alloc] init];
    }
    return _storyLoader;
}

- (NSMutableArray*) stories {
    if (!_stories){
        _stories = [[NSMutableArray alloc] init];
    }

    return _stories;
}

- (NSMutableArray*) newStories {
    if (!_newStories){
        _newStories = [[NSMutableArray alloc] init];
    }

    return _newStories;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == (self.storiesLoaded - MAX_STORIES/2)){
          [(UIActivityIndicatorView*)tableView.tableFooterView startAnimating];
        NSLog(@"load more");
        [self loadMoreStories:self.storiesLoaded + MAX_STORIES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    Story *story = [self.stories objectAtIndex:indexPath.row];

    cell.title.text = story.title;
    cell.url.text = story.url;
    cell.by.text = story.by;
    NSString *comments = (story.comments.intValue > 1) ? @"comments" : @"comment";
    cell.comments.text = story.comments.intValue > 0 ? [[NSString stringWithFormat:@"%d ",story.comments.intValue] stringByAppendingString:comments] : @"";

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self performSegueWithIdentifier:@"showPage" sender:self];
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewsModeViewController *newsController = segue.destinationViewController;
        Story *s = [self.stories objectAtIndex:indexPath.row];
        newsController.storyTitle = s.title;
        newsController.url = s.url;
    }
}


@end
