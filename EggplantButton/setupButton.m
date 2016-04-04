//
//  setupButton.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/4/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "setupButton.h"
#import "Secrets.h"
#import <Button/Button.h>

@interface setupButton ()

@property BTNDropinButton * button;

@end

@implementation setupButton

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButton];
    


}

- (void) setupButton {
    
    // Initializing button
    self.button = [[BTNDropinButton alloc] initWithButtonId:YOUR_BUTTON_ID];
    [self.view addSubview:self.button];
    
    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 15.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:16.0]];
    [[BTNDropinButton appearance] setTextColor:[UIColor blackColor]];
    [[BTNDropinButton appearance] setBorderColor:[UIColor blackColor]];
    [[BTNDropinButton appearance] setBorderWidth:2];
    
//    // Setup your context.
//    BTNLocation *userLocation = [BTNLocation locationWithLatitude:<#latitude#> longitude:<#longitude#>];
//    BTNContext *context = [BTNContext contextWithUserLocation:userLocation];
    
    BTNLocation *location = [BTNLocation locationWithName:@"Parm"
                                                 latitude:40.7237889
                                                longitude:-73.997];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    [self.button prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
        }
    }];
    
   
    

    
    
}

@end
