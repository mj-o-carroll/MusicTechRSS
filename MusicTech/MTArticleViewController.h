//
//  DetailViewController.h
//  MusicTech
//
//  Created by MJ O'CARROLL on 12/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//
//  MusicTech.net article view controller

#import <UIKit/UIKit.h>

@interface MTArticleViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}

@property (strong, nonatomic) id detailItem;
@property(nonatomic, strong) NSURL* feedURL;

- (IBAction)shareTapped:(id)sender;

@end
