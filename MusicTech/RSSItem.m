//
//  RSSItem.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 12/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//

#import "RSSItem.h"
#import "GTMNSString+HTML.h"
#import "NSString+stripHtml.h"

@implementation RSSItem

@synthesize link, description, content;

-(NSAttributedString*)cellMessage
{
    if (_cellMessage!=nil) return _cellMessage;
    
    NSDictionary* boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0]};
    NSDictionary* normalStyle = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0]};
    NSString*title = [[NSString alloc] initWithFormat:@"%@\n\n", self.title];
    
    NSMutableAttributedString* articleAbstract = [[NSMutableAttributedString alloc] initWithString:title];
    
    [articleAbstract setAttributes:boldStyle
                             range:NSMakeRange(0, self.title.length)];
    
    [articleAbstract appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    int startIndex = [articleAbstract length];
    
    //description = [NSString stringWithFormat:@"%@...", [self.description substringToIndex:100]];
    NSString* dots;
    int length = [self.description length];
    if (length > 100) {
        length = 100;
        dots = [NSString stringWithFormat:@"..."];
    }
    else {
        dots = [NSString stringWithFormat:@""];
    }
    description = [NSString stringWithFormat:@"%@%@", [self.description substringToIndex:length], dots];
    description = [description gtm_stringByUnescapingFromHTML];
    
    description = [description stripHtml];
    
    [articleAbstract appendAttributedString:[[NSAttributedString alloc] initWithString:description]];
    
    [articleAbstract setAttributes:normalStyle
                             range:NSMakeRange(startIndex, articleAbstract.length - startIndex)];
    
    _cellMessage = articleAbstract;
    return _cellMessage;
    
}


@end
