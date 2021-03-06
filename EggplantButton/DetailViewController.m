//
//  DetailViewController.m
//  EasyOut
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "DetailViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSGeometryUtils.h>
#import <AFNetworking/AFImageDownloader.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <SafariServices/SafariServices.h>

#import "Constants.h"
#import "Secrets.h"


@interface DetailViewController () <SFSafariViewControllerDelegate>

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

@property (weak, nonatomic) IBOutlet UIButton *moreDetail;
@property (weak, nonatomic) IBOutlet UIButton *uberButton;

//@property (nonatomic, strong) BTNDropinButton *dropinButton;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;

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
    
    [self generateGoogleMap];

}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];


    [self downloadImageWithURL:self.activity.imageURL setTo:self.imageView];
    
    [self downloadImageWithURL:self.activity.icon setTo:self.iconImage];
    
    self.nameLabel.text = self.activity.name;
    
    self.typeLabel.text = self.activity.type;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ miles away", self.activity.distance];

    [self setupAttributedLabels];
    
    [self getDistanceFromLocation];

    [self setupUberButton];
}


-(void)setupAttributedLabels {
    
    FAKFontAwesome *clockIcon = [FAKFontAwesome clockOIconWithSize:25];
    [clockIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFoundationIcons *mapIcon = [FAKFoundationIcons markerIconWithSize:25];
    [mapIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *fourIcon = [FAKFontAwesome foursquareIconWithSize:25];
    [fourIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSMutableAttributedString *clockString = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSAttributedString *clockAttr = [clockIcon attributedString];
    [clockString appendAttributedString: clockAttr];
    [clockString appendAttributedString: [[NSAttributedString alloc]initWithString: [NSString stringWithFormat: @"  %@", self.activity.openStatus]]];
    self.hoursLabel.attributedText =  clockString;
    
    NSMutableAttributedString *mapString = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSAttributedString *mapAtr = [mapIcon attributedString];
    [mapString appendAttributedString: mapAtr];
    [mapString appendAttributedString: [[NSAttributedString alloc]initWithString: [NSString stringWithFormat: @"  %@ %@", self.activity.address[0], self.activity.address[1]]]];
    self.addressLabel.attributedText = mapString;
    
    NSMutableAttributedString *fourString = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSAttributedString *fourAtr = [fourIcon attributedString];
    [fourString appendAttributedString: fourAtr];
    [fourString appendAttributedString: [[NSAttributedString alloc]initWithString: @"  More Detail"]];
    [self.moreDetail setAttributedTitle: fourString forState: UIControlStateNormal];

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

    NSLog(@"Distance: %f", distance);
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
    
    //COORDINATES FOR USER AND ACTIVITY
    
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];
    CLLocationCoordinate2D location = [self getLocationFromAddressString: address];
    CLLocationCoordinate2D user = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    self.mapView = [[GMSMapView alloc]init];
    
    [self.mapView setMinZoom:14 maxZoom:18];
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:location coordinate:user];
    
//    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsZero]];
    
    GMSCameraPosition *camera = [self.mapView cameraForBounds:bounds insets:UIEdgeInsetsZero];
    self.mapView.camera = camera;
    
    [self.mapUIView addSubview:self.mapView];


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

}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    [[self navigationController] popViewControllerAnimated:NO];
}


- (IBAction)detailButtonPressed:(UIButton *)sender {
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@?ref:%@", self.activity.moreDetailsURL,FOURSQUARE_CLIENT_ID]]];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:NO completion:nil];
}



- (IBAction)uberButtonTapped:(id)sender {

}

- (void)setupUberButton {
//
//    // Initialize Button integration
//    [[Button sharedButton] configureWithApplicationId:BUTTON_APP_ID
//                                           completion:NULL];
//
//    // Allow Button to request location
//    [Button allowButtonToRequestLocationPermission:YES];
//
//    // Set up Uber Button
//    self.dropinButton = [[BTNDropinButton alloc] initWithButtonId:BUTTON_APP_ID];
//    [self.uberIcon addSubview:self.dropinButton];
//
//    // Set Uber Button appearance
//    [self.dropinButton.leadingAnchor constraintEqualToAnchor:self.uberIcon.leadingAnchor].active = YES;
//    [self.dropinButton.trailingAnchor constraintEqualToAnchor:self.uberIcon.trailingAnchor].active = YES;
//    [self.dropinButton.topAnchor constraintEqualToAnchor:self.uberIcon.topAnchor].active = YES;
//    [self.dropinButton.bottomAnchor constraintEqualToAnchor:self.uberIcon.bottomAnchor].active = YES;
//
//    self.dropinButton.alpha = 0.01;
//
//    BTNLocation *location = [BTNLocation locationWithLatitude:self.latitude
//                                                    longitude:self.longitude];
//
//    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
//
//    // Check if Uber is available and display button if it is
//    [[Button sharedButton] willDisplayButtonWithId:BUTTON_APP_ID
//                                           context:context
//                                        completion:^(BOOL willDisplay) {
//        if (willDisplay) {
//            // An action is available for this button and context.
//
//            // Prepare the Button for display
//            [self.dropinButton prepareWithContext:context completion:^(BOOL isDisplayable) {
//                if (!isDisplayable) {
//                    // Hide the Uber icon
//                    self.uberIcon.alpha = 0.0;
//                }
//            }];
//        }
//    }];
}

@end
