//
//  ActivityCard.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCard.h"
#import "RestaurantDataStore.h"

@interface ActivityCard ()

@property (strong, nonatomic) RestaurantDataStore *sharedDataStore;

@end

@implementation ActivityCard

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
     
        self.sharedDataStore = [RestaurantDataStore sharedDataStore];
        
        
        
    }
    return self;
}

-(void)setForecastModel:(CurrentForcast *)forecastModel {
    _forecastModel = forecastModel;
    [self updateUI];
}



@end
