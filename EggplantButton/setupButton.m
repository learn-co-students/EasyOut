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

@property (nonatomic, strong) BTNDropinButton * rezybutton;
@property (nonatomic, strong) BTNDropinButton * uberbutton;

@end

@implementation setupButton

- (void)viewDidLoad {
    [super viewDidLoad];
    
   //[self setupRezyButton];
    
    [self setupUberButton];

}

- (void) setupRezyButton {
    
    // Initializing button
    self.rezybutton = [[BTNDropinButton alloc] initWithButtonId:REZY_BUTTON_ID];
    [self.view addSubview:self.rezybutton];
    
    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 15.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:10.0]];
    [[BTNDropinButton appearance] setTextColor:[UIColor whiteColor]];
    [[BTNDropinButton appearance] setBorderColor:[UIColor redColor]];
    [[BTNDropinButton appearance] setBackgroundColor:[UIColor redColor]];
    [[BTNDropinButton appearance] setBorderWidth:1];
    
//    // Setup your context.
//    BTNLocation *userLocation = [BTNLocation locationWithLatitude:<#latitude#> longitude:<#longitude#>];
//    BTNContext *context = [BTNContext contextWithUserLocation:userLocation];
    
    BTNLocation *location = [BTNLocation locationWithName:@"Parm"
                                                 latitude:40.7237889
                                                longitude:-73.997];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    [self.rezybutton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
        }
    }];
    
}

- (void) setupUberButton {
    
    // Initializing button
    self.uberbutton = [[BTNDropinButton alloc] initWithButtonId:UBER_BUTTON_ID];
    [self.view addSubview:self.uberbutton];
    
    //[[BTNDropinButton appearanceWhenContainedInInstancesOfClasses:@[[self.uberbutton class]]] setBackgroundColor:[UIColor blueColor]];
    
 //   [self.uberbutton.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = YES;
    
//    [self.uberbutton.widthAnchor constraintEqualToConstant:180].active = YES;
//    [self.uberbutton.heightAnchor constraintEqualToConstant:40].active = YES;
//    [self.uberbutton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    
    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 15.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:12.0]];
    [[BTNDropinButton appearance] setBorderWidth:1];
    [[BTNDropinButton appearance] setCornerRadius: 5.0];
    [[BTNDropinButton appearance] setHighlightedBackgroundColor:[UIColor lightGrayColor]];
    [[BTNDropinButton appearance] setHighlightedTextColor:[UIColor whiteColor]];
    
    //    // Setup your context.
    //    BTNLocation *userLocation = [BTNLocation locationWithLatitude:<#latitude#> longitude:<#longitude#>];
    //    BTNContext *context = [BTNContext contextWithUserLocation:userLocation];
    
    BTNLocation *location = [BTNLocation locationWithName:@"Parm"
                                                 latitude:40.7237889
                                                longitude:-73.997];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    [self.uberbutton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
        }
    }];
    
}

@end
