//
//  CircleLabelView.h
//  EggplantButton
//
//  Created by Stephanie on 4/19/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LabelType) {
    Tips,
    Ratings,
    Itineraries
};



@interface CircleLabelView : UIView


@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic) LabelType type;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

-(void)createCircleLabel;

@end
