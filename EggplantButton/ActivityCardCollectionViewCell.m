//
//  ActivityCardCollectionViewCell.m
//  EggplantButton
//
//  Created by Stephanie on 4/8/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardCollectionViewCell.h"

@implementation ActivityCardCollectionViewCell

-(instancetype)init {
    
    self = [super init];
    if(self) {
        
        self.cardView = [[ActivityCardView alloc]init];
        
        [self.contentView addSubview:self.cardView];
        
        self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.cardView.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
        [self.cardView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = YES;
        [self.cardView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
        [self.cardView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
        
    }
    return self;
}


@end
