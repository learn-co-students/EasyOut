//
//  ItineraryReviewTableViewCell.m
//  EggplantButton
//
//  Created by Stephanie on 4/24/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryReviewTableViewCell.h"

@implementation ItineraryReviewTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];

    }
    return self;
}

-(void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"ItineraryReviewCell" owner:self options:nil];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.view];
    
    [self.view.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.view.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
}



@end
