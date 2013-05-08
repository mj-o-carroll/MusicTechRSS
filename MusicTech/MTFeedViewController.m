//
//  RSSFeedViewController.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 13/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "MTFeedViewController.h"
#import "MTArticleViewController.h"
#import "TableHeaderView.h"
#import "RSSLoader.h"
#import "RSSItem.h"

@interface MTFeedViewController ()
{
    NSArray *_objects;
    UIRefreshControl* refreshControl;
}
@end

@implementation MTFeedViewController

@synthesize feedURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //reshow navigation bar
    [self.navigationController setNavigationBarHidden:NO];
    
    //set up custom back button
    UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    //swipe gesture
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

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)back
{    
    [self.navigationController popViewControllerAnimated:YES];
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
                        UIImage* newImage = [UIImage imageNamed:@"MTHeader.png"];
                        [(TableHeaderView*)self.tableView.tableHeaderView setText:title];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
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
    if ([[segue identifier] isEqualToString:@"ToWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        MTArticleViewController * mtArticleViewController = [segue destinationViewController];
        mtArticleViewController.feedURL = object.link;
    }
}

@end
