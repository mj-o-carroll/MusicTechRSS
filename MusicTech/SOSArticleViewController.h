//
//  LatestNewsViewController.h
//  MusicTech
//
//  Created by MJ O'CARROLL on 16/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "ArticleTitle.h"
#import "ArticleContent.h"
#import <Social/Social.h>

@interface SOSArticleViewController : UIViewController
{
    ArticleTitle *article;
    ArticleContent * articleContent;
    NSMutableString *totalContent;
}

@property(nonatomic, strong) NSURL* feedURL;
@property(nonatomic, strong) IBOutlet UILabel* articleTitle;
@property(nonatomic, strong) IBOutlet UILabel* articleSubTitle;
@property(nonatomic, strong) IBOutlet UITextView* articleDisplay;

- (IBAction)shareTapped:(id)sender;

@end
