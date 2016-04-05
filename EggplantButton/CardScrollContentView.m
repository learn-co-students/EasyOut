//
//  CardScrollContentView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "CardScrollContentView.h"

@implementation CardScrollContentView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit {
    
    self.card = [[ActivityCardView alloc]init];
    
    [self addSubview: self.card];
    
//    [self.card.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
//    [self.card.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
//    [self.card.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
//    [self.card.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.card.clipsToBounds = YES;
    
}


@end
