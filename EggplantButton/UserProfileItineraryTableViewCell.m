//
//  UserProfileItineraryTableViewCell.m
//  EasyOut
//
//  Created by Ian Alexander Rahman on 5/3/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "UserProfileItineraryTableViewCell.h"

@implementation UserProfileItineraryTableViewCell

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
    
    NSLog(@"User profile itinerary history table view cell initializing");
    
    [[NSBundle mainBundle] loadNibNamed:@"UserProfileItineraryTableViewCell" owner:self options:nil];
    
    [self addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.view.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    self.view.layer.borderWidth = 2.0;
    
    self.itinerary = [[Itinerary alloc] init];
}


@end
