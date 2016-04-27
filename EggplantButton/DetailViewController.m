//
//  DetailViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSGeometryUtils.h>
#import <AFNetworking/AFImageDownloader.h>
#import "Constants.h"
#import "Secrets.h"
#import <Button/Button.h>


@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;

@property (weak, nonatomic) IBOutlet UIView *mapUIView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *uberIcon;
@property (weak, nonatomic) IBOutlet UIButton *uberButton;

@property (strong, nonatomic) BTNDropinButton * longUberButton;

@property (nonatomic, strong) BTNDropinButton *dropinButton;
@property (weak, nonatomic) UIActivityIndicatorView * spinner;

@end


@implementation DetailViewController

- (void) viewWillAppear:(BOOL)animated {
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake((self.view.frame.size.width/2), (self.view.frame.size.height/2));
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.spinner removeFromSuperview];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self generateGoogleMap];

    [self downloadImageWithURL:self.activity.imageURL setTo:self.imageView];
    [self downloadImageWithURL:self.activity.icon setTo:self.iconImage];
    self.nameLabel.text = self.activity.name;
    self.typeLabel.text = self.activity.type;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ miles away", self.activity.distance];
    self.hoursLabel.text = self.activity.openStatus;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];

    [self getDistanceFromLocation];

    //[self setupUberButton];
    
    [self setupRealUberButton];
}

-(void)setImageIcon:(UIImage*)image WithText:(NSString*)strText forLabel:(UILabel *)label{

    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    float offsetY = -label.bounds.size.height/2.0; //This can be dynamic with respect to size of image and UILabel
    attachment.bounds = CGRectIntegral( CGRectMake(0, offsetY, label.frame.size.height, label.frame.size.height));

    NSMutableAttributedString *attachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:strText];

    [attachmentString appendAttributedString:myString];

    label.attributedText = attachmentString;
}


-(void)downloadImageWithURL:(NSURL *)imageURL setTo:(UIImageView *)imageView {

    AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
    downloader.downloadPrioritizaton = AFImageDownloadPrioritizationLIFO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];

    imageView.image = nil;

    Activity *activityWhoseImageWeAreDownloading = self.activity;

    [downloader downloadImageForURLRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
        if(self.activity == activityWhoseImageWeAreDownloading) {
            imageView.image = responseObject;
        }
    } failure:nil];

}

-(void)getDistanceFromLocation {

    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];

    NSString *address = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];

    CLLocationCoordinate2D location = [self getLocationFromAddressString: address];

    CLLocation *activityLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];

    CLLocationDistance distance = [userLocation distanceFromLocation: activityLocation];

    NSLog(@"%f", distance);
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {

    [[self navigationController] popViewControllerAnimated:YES];
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }

    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;

    return center;
}

-(void)generateGoogleMap {

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:14];

    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.mapUIView addSubview:self.mapView];

    //COORDINATES FOR USER AND ACTIVITY

    NSString *address = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];
    CLLocationCoordinate2D location = [self getLocationFromAddressString: address];


    // CONSTRAINTS
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.mapView.topAnchor constraintEqualToAnchor:self.mapUIView.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.mapUIView.bottomAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.mapUIView.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.mapUIView.trailingAnchor].active = YES;

    //MARKER FOR US
    GMSMarker *userLoc = [[GMSMarker alloc]init];
    userLoc.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    userLoc.map = self.mapView;

    //MARKER FOR ACTIVITIES
    UIImage *markerImage = [GMSMarker markerImageWithColor:[Constants vikingBlueColor]];

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location;
    marker.title = self.activity.name;
    marker.snippet = address;
    marker.map = self.mapView;
    marker.icon = markerImage;

//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:user coordinate:location];
//
////    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
//
//
//    camera = [self.mapView cameraForBounds:bounds insets:UIEdgeInsetsZero];
//    self.mapView.camera = camera;
}


- (IBAction)detailButtonPressed:(id)sender {

    [[UIApplication sharedApplication] openURL: self.activity.moreDetailsURL];
}

- (IBAction)uberButtonTapped:(id)sender {

}

- (void) setupRealUberButton {
    self.longUberButton = [[BTNDropinButton alloc] initWithButtonId:@"UBER_BUTTON_ID"];
    [self.view addSubview:self.longUberButton];
    
    self.longUberButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.longUberButton.heightAnchor constraintEqualToConstant:40.0f].active = YES;
    [self.longUberButton.widthAnchor constraintEqualToConstant:180.0f].active =YES;
    [self.longUberButton.bottomAnchor constraintEqualToAnchor:self.mapUIView.bottomAnchor constant:-10].active = YES;
    [self.longUberButton.rightAnchor constraintEqualToAnchor:self.uberIcon.leftAnchor constant:-10].active = YES;
    
    [[BTNDropinButton appearance] setBackgroundColor:[UIColor whiteColor]];
    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 15.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:12.0]];
    [[BTNDropinButton appearance] setTextColor:[UIColor blackColor]];
    [[BTNDropinButton appearance] setBorderWidth:1];
    [[BTNDropinButton appearance] setCornerRadius: 5.0];
    [[BTNDropinButton appearance] setHighlightedBackgroundColor:[UIColor lightGrayColor]];
    [[BTNDropinButton appearance] setHighlightedTextColor:[UIColor whiteColor]];
    
    BTNLocation *location = [BTNLocation locationWithLatitude:self.latitude
                                                    longitude:self.longitude];
    
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    
    
    // Check if Uber is available and display button if it is
    [self.longUberButton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
            self.longUberButton.alpha = 0;
        }
    }];

}


- (void)setupUberButton {

    // Set up Uber Button
    self.dropinButton = [[BTNDropinButton alloc] initWithButtonId:UBER_BUTTON_ID];
    [self.uberIcon addSubview:self.dropinButton];

    // Set Uber Button appearance
    [self.dropinButton.leadingAnchor constraintEqualToAnchor:self.uberIcon.leadingAnchor].active = YES;
    [self.dropinButton.trailingAnchor constraintEqualToAnchor:self.uberIcon.trailingAnchor].active = YES;
    [self.dropinButton.topAnchor constraintEqualToAnchor:self.uberIcon.topAnchor].active = YES;
    [self.dropinButton.bottomAnchor constraintEqualToAnchor:self.uberIcon.bottomAnchor].active = YES;

    self.dropinButton.alpha = 0.01;

    BTNLocation *location = [BTNLocation locationWithLatitude:self.latitude
                                                    longitude:self.longitude];

    BTNContext *context = [BTNContext contextWithSubjectLocation:location];



    // Check if Uber is available and display button if it is
    [[Button sharedButton] willDisplayButtonWithId:UBER_BUTTON_ID
                                           context:context
                                        completion:^(BOOL willDisplay) {
        if (willDisplay) {
            // An action is available for this button and context.

            // Prepare the Button for display
            [self.dropinButton prepareWithContext:context completion:^(BOOL isDisplayable) {
                if (!isDisplayable) {
                    // Hide the Uber icon
                    self.uberIcon.alpha = 0.0;
                }
            }];
        }
    }];
}


@end
