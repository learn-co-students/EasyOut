
//
//  ActivityCardView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardView.h"
#import "Restaurant.h"

@interface ActivityCardView ()

//@property (strong, nonatomic) RestaurantDataStore *sharedDataStore;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricepointLabel;


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

    [[NSBundle mainBundle] loadNibNamed:@"ActivityCard" owner:self options:nil];

    [self addSubview:self.contentView];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = YES;
    [self.contentView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
    
}

-(void)setRestaurant:(Restaurant *)restaurant {

    _restaurant = restaurant;
    [self updateUI];
}

-(void)updateUI {
    
    self.nameLabel.text = self.restaurant.name;
    self.addressLabel.text = self.restaurant.address;
    self.pricepointLabel.text = self.restaurant.price;
    
}


@end
