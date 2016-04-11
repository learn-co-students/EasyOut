
//
//  ActivityCardView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardView.h"
<<<<<<< HEAD

=======
#import "Event.h"
>>>>>>> origin

@interface ActivityCardView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


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
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = YES;
    [self.contentView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
}

-(void)setActivity:(Activity *)activity {
    
    _activity = activity;
    [self updateUI];
}


// Add data to activity card view
-(void)updateUI {
    
    self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.activity.imageURL]];
    self.nameLabel.text = self.activity.name;
    self.addressLabel.text = self.activity.address;
    
    switch (self.activity.activityType) {
        case RestaurantType:
            self.detailLabel.text = ((Restaurant *)self.activity).price;
            break;
        case EventType:
            self.detailLabel.text = ((Event *)self.activity).time;
            break;
        default:
            break;
    }

}




@end
