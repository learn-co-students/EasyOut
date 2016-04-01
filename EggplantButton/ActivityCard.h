//
//  ActivityCard.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCard : UIView

@property (strong, nonatomic) IBOutlet ActivityCard *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricepointLabel;

@end
