//
//  RSSLoader.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 12/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "RSSLoader.h"
#import "RXMLElement.h"
#import "RSSItem.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation RSSLoader

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c
{
    dispatch_async(kBgQueue, ^{
        
        //work in the background
        RXMLElement *rss = [RXMLElement elementFromURL: url];
        
            RXMLElement* title = [[rss child:@"channel"] child:@"title"];
            NSArray* items = [[rss child:@"channel"] children:@"item"];
            
            NSMutableArray* result = [NSMutableArray arrayWithCapacity:items.count];
            
            //more code
            for (RXMLElement *e in items) {
                
                //iterate over the articles
                RSSItem* item = [[RSSItem alloc] init];
                item.title = [[e child:@"title"] text];
                item.description = [[e child:@"description"] text];
                item.date = [[e child:@"pubDate"] text];
                item.link = [NSURL URLWithString: [[e child:@"link"] text]];
                [result addObject: item];
                NSLog(@"TITLE: %@ ", item.title);
                NSLog(@"DESCRIPTION: %@ ", item.description);
                NSLog(@"LINK: %@ ", item.link);
                NSLog(@"DATE: %@ ", item.date);
                NSLog(@"CONTENT: %@ ", item.content);
            }
            
            c([title text], result);
    });
}

@end
