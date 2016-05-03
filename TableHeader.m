//
//  TableHeader.m
//  EasyOut
//
//  Created by Stephanie on 5/3/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "TableHeader.h"

@implementation TableHeader

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
    
    [[NSBundle mainBundle] loadNibNamed:@"TableHeader" owner:self options:nil];
    
    [self addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
    [self.view.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
    [self.view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.view.layer.borderWidth = 2.0;
    
}

@end
