//
//  CircleLabelView.m
//  EasyOut
//
//  Created by Stephanie on 4/19/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "CircleLabelView.h"

@interface CircleLabelView ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation CircleLabelView

-(void)createCircleLabel {
    
    [[NSBundle mainBundle] loadNibNamed:@"CircleLabel" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    self.layer.cornerRadius = (self.frame.size.width)/2;
    self.clipsToBounds = YES;

    switch (self.type) {
        case Tips:
            self.typeLabel.text = @"Tips";
            break;
        case Ratings:
            self.typeLabel.text = @"Ratings";
            break;
        case Itineraries:
            self.typeLabel.text = @"Itineraties";
            break;
        default:
            break;
    }
    
    
    
}

@end
