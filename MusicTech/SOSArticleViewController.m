//
//  LatestNewsViewController.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 16/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "SOSArticleViewController.h"

@interface SOSArticleViewController ()

@end

@implementation SOSArticleViewController

@synthesize feedURL, articleDisplay, articleTitle, articleSubTitle;

-(void)loadArticleTitle
{
    NSData *articleHtmlData = [NSData dataWithContentsOfURL:feedURL];
    TFHpple *articleParser = [TFHpple hppleWithHTMLData:articleHtmlData];
    NSString *titleXpathQueryString = @"//h1[@class='NewsTitle']";
    NSArray *titleNodes = [articleParser searchWithXPathQuery:titleXpathQueryString];
    NSString *subTitleXpathQueryString = @"//h2[@class='NewsSubTitle']";
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

-(void)loadArticleContent
{
    NSData *articleHtmlData = [NSData dataWithContentsOfURL:feedURL];
    TFHpple *articleParser = [TFHpple hppleWithHTMLData:articleHtmlData]; 
    NSString *contentXpathQueryString = @"//p | //p/span";
    //NSString *contentXpathQueryString = @"//p/descendant-or-self::*/text()";
    //div/descendant-or-self::*/text()
    NSArray *contentNodes = [articleParser searchWithXPathQuery:contentXpathQueryString];
    NSMutableArray *pTags = [[NSMutableArray alloc] initWithCapacity:0];
   
    for (TFHppleElement *element in contentNodes)
    {
        articleContent = [[ArticleContent alloc] init];
        articleContent.content = [[element firstChild] content];
        NSString*pTag = [NSString stringWithFormat:@"%@",articleContent.content];
        NSLog(@"CONTENT: %@",pTag);
        [pTags addObject:pTag];
    }
    articleDisplay.text = [NSString stringWithFormat:@"%@", articleContent.content];
    totalContent = [NSMutableString string];
    
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
    if (self)
    {
        // Custom initialization
    }
    return self;
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
    
	// Do any additional setup after loading the view.
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

- (IBAction)shareTapped:(id)sender
{
    NSString *message = [[NSString alloc] initWithFormat:@"I'm reading a great article from Sound On Sound. Check it here - %@", feedURL];
    NSArray *postItems = @[message];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
