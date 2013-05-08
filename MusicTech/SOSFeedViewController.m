//
//  LatestNewsFeedViewController.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 16/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "SOSFeedViewController.h"
#import "SOSArticleViewController.h"
#import "MTArticleViewController.h"
#import "TableHeaderView.h"
#import "RSSLoader.h"
#import "RSSItem.h"

@interface SOSFeedViewController ()
{
    NSArray *_objects;
    UIRefreshControl* refreshControl;
}
@end

@implementation SOSFeedViewController

@synthesize feedURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    NSString* fetchMessage = [NSString stringWithFormat:@"Fetching: %@",feedURL];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview: refreshControl];
    
    //add the header
    self.tableView.tableHeaderView = [[TableHeaderView alloc] initWithText:@"Fetching rss feed"];
    
    [self refreshFeed];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

-(void)refreshFeed
{
    RSSLoader* rss = [[RSSLoader alloc] init];
    [rss fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {
                    
                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //UI code on the main queue
                        UIImage* newImage = [UIImage imageNamed:@"SOSHeaderImg.png"];
                        [(TableHeaderView*)self.tableView.tableHeaderView setText:@"Sound On Sound"];
                        [(TableHeaderView*)self.tableView.tableHeaderView setImage:newImage];
                        
                        _objects = results;
                        [self.tableView reloadData];
                
                        // Stop refresh control
                        [refreshControl endRefreshing];
                    });
                }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestNewsCell" forIndexPath:indexPath];
    
    RSSItem *object = _objects[indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.description;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [_objects objectAtIndex:indexPath.row];
    CGRect cellMessageRect = [item.cellMessage boundingRectWithSize:CGSizeMake(200,10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    return cellMessageRect.size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action: nil];
    if ([[segue identifier] isEqualToString:@"ToNewsArticle"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = _objects[indexPath.row];
        SOSArticleViewController * latestNewsViewController = [segue destinationViewController];
        latestNewsViewController.feedURL = object.link;
    }
}

@end
