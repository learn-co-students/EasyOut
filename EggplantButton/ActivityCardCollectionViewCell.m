//
//  ActivityCardCollectionViewCell.m
//  EggplantButton
//
//  Created by Stephanie on 4/8/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardCollectionViewCell.h"
#import "Constants.h"

@implementation ActivityCardCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
        self.cardView = [[ActivityCardView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.cardView];
        
        self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.cardView.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
        [self.cardView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = YES;
        [self.cardView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
        [self.cardView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
            
    }


@end
