//
//  MenuView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "MenuView.h"
#import "ActivityCardView.h"
#import "RestaurantDataStore.h"

@interface MenuView ()

@property (strong, nonatomic) RestaurantDataStore *sharedDataStore;

@end


@implementation MenuView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
     
        self.sharedDataStore = [RestaurantDataStore sharedDataStore];
        
        
        
    }
    return self;
}



@end
