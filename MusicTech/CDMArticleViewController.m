//
//  CMViewController.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 18/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "CDMArticleViewController.h"

@interface CDMArticleViewController ()

@end

@implementation CDMArticleViewController

@synthesize feedURL, articleDisplay, articleTitle, articleSubTitle;

//  get article title from website
-(void)loadArticleTitle
{
    NSData *articleHtmlData = [NSData dataWithContentsOfURL:feedURL];
    TFHpple *articleParser = [TFHpple hppleWithHTMLData:articleHtmlData];
    NSString *titleXpathQueryString = @"//title";
    NSArray *titleNodes = [articleParser searchWithXPathQuery:titleXpathQueryString];
    NSString *subTitleXpathQueryString = @"//div[@class='column']/p";
    NSArray *subTitleNodes = [articleParser searchWithXPathQuery:subTitleXpathQueryString];
    
    for (TFHppleElement *element in titleNodes)
    {
        article = [[ArticleTitle alloc] init];
        article.title = [[element firstChild] content];
    }
    [articleTitle setText:[NSString stringWithFormat:@"%@", article.title]];
    
    for (TFHppleElement *element in subTitleNodes)
    {
        article.subTitle = [[element firstChild] content];
    }
    [articleSubTitle setText:[NSString stringWithFormat:@"%@", article.subTitle]];
    
    [self reloadInputViews];
}

//  get article content from website
-(void)loadArticleContent {
    
    NSData *articleHtmlData = [NSData dataWithContentsOfURL:feedURL];
    TFHpple *articleParser = [TFHpple hppleWithHTMLData:articleHtmlData];
    
    //NSString *contentXpathQueryString = @"//p | //p/span | //p/a";
    NSString *contentXpathQueryString = @"//section//p | //section/p/a | //section/p/a/following-sibling::text()[1] | //section/a | //section/p/a/em";
    NSArray *contentNodes = [articleParser searchWithXPathQuery:contentXpathQueryString];
    NSMutableArray *pTags = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in contentNodes)
    {
        articleContent = [[ArticleContent alloc] init];
        articleContent.content = [[element firstChild] content];
        NSString*pTag = [NSString stringWithFormat:@"%@",articleContent.content];
        [pTags addObject:pTag];
    }
    
    [pTags removeObjectAtIndex:0];
    articleDisplay.text = [NSString stringWithFormat:@"%@", articleContent.content];
    totalContent = [NSMutableString string];
    
    //convert content nodes to one string for display
    for( NSString *contentPiece in pTags)
    {
        NSString*nothing = [NSString stringWithFormat:@"(null)"];
        if(![contentPiece isEqualToString:nothing])
            [totalContent appendString:[NSString stringWithFormat:@"%@\n", contentPiece]];
    }
    articleDisplay.text = totalContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)shareTapped:(id)sender
{
    NSString *message = [[NSString alloc] initWithFormat:@"I'm reading a great article from Create Digital Music. Check it here - %@", feedURL];
    NSArray *postItems = @[message];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self loadArticleTitle];
    [self loadArticleContent];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
