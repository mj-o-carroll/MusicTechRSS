//
//  TableHeaderView.m
//  MusicTech
//
//  Created by MJ O'CARROLL on 12/04/2013.
//  Copyright (c) 2013 MJ O'CARROLL. All rights reserved.
//


#import "TableHeaderView.h"

@interface TableHeaderView()
{
	UILabel* label;
}
@end

@implementation TableHeaderView

- (id)initWithText:(NSString*)text
{
	UIImage* img = [UIImage imageNamed:@"arss_header.png"];
    if ((self = [super initWithImage:img]))
    {
        // Initialization code
		label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,200,70)];
		label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0];
		label.text = text;
		label.numberOfLines = 3;
		[self addSubview:label];
    }
    return self;
}

- (void)setText:(NSString*)text
{
	label.text = text;
}

@end