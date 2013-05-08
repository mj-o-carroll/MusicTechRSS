//
//  MenuViewController.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 13/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//
//  Main Menu

#import "MenuViewController.h"
#import "SOSFeedViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize feedURL, logo, logoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //hide navigation controller on this view
    [self.navigationController setNavigationBarHidden:YES];
}

    //hide navigation controller when this view reappears
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //remove default text from back button
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action: nil];
    
    if([segue.identifier isEqualToString:@"ToSoundOnSound"])
    {
        feedURL = [NSURL URLWithString:@"http://www.soundonsound.com/news/sosrssfeed.php"];
        NSLog(@"TITLE: %@ ", feedURL);
        SOSFeedViewController * latestNewsFeedViewController = [segue destinationViewController];
        latestNewsFeedViewController.feedURL = feedURL;
    }
    else if([segue.identifier isEqualToString:@"ToMusicTech"])
    {
        feedURL = [NSURL URLWithString:@"http://www.musictech.net/feed/"];
        MTFeedViewController * rssFeedViewController = [segue destinationViewController];
        rssFeedViewController.feedURL = feedURL;
    }
    else if([segue.identifier isEqualToString:@"ToCreativeMusic"])
    {
        feedURL = [NSURL URLWithString:@"http://createdigitalmusic.com/feed/"];
        MTFeedViewController * rssFeedViewController = [segue destinationViewController];
        rssFeedViewController.feedURL = feedURL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
