//
//  CircleLabelView.m
//  EggplantButton
//
//  Created by Stephanie on 4/19/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "CircleLabelView.h"

@implementation CircleLabelView

-(void)createCircleLabel {
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    self.layer.cornerRadius = self.frame.size.width/2;
    
}

@end
