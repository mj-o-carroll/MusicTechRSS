//
//  MenuViewController.h
//  MusicTech
//
//  Created by MJ O'CARROLL on 13/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//
//  Main Menu Screen

#import <UIKit/UIKit.h>
#import "MTFeedViewController.h"
#import "SOSFeedViewController.h"

@interface MenuViewController : UIViewController

@property (nonatomic, strong) NSURL* feedURL;
@property (nonatomic, strong) UIImage* logoImage;
@property (nonatomic, strong) IBOutlet UIImageView* logo;

@end
