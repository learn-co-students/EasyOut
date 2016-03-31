//
//  ActivityCardView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardView.h"

@interface ActivityCardView ()

@property (strong, nonatomic) IBOutlet UIView *activityCardContentView;


@end

@implementation ActivityCardView

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
    [[NSBundle mainBundle] loadNibNamed:@"ActivityCardView" owner:self options:nil];
    
    [self addSubview:self.activityCardContentView];
    
    // Create all the common activity card attributes
    
}



@end
