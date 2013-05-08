//
//  TableHeaderView.h
//  MusicTech
//
//  Created by MJ O'CARROLL on 12/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//
//  Table Header View for each RSS feed list

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIImageView
- (id)initWithText:(NSString*)text;
- (void)setText:(NSString*)text;
@end
