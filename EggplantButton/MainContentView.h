//
//  MainContentView.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityCardView;
@interface MainContentView : UIView

@property (strong, nonatomic) IBOutlet ActivityCardView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricepointLabel;

@end
