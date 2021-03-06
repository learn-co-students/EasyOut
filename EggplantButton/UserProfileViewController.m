//
//  UserProfileViewController.m
//  EasyOut
//
//  Created by Stephanie on 4/13/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EasyOut-Swift.h"
#import "Firebase.h"
#import "Secrets.h"
#import "Itinerary.h"
#import "CircleLabelView.h"
#import "UserProfileItineraryTableViewCell.h"
#import "ItineraryViewController.h"
#import "Constants.h"


@interface UserProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITableView *itineraryTable;
@property (strong, nonatomic) NSMutableArray *itineraries;
@property (strong, nonatomic) Itinerary *itinerary;

// LOCATION
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end


@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.contentMode = UIViewContentModeCenter;
    self.view.contentMode = UIViewContentModeScaleAspectFit;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.itineraries = [[NSMutableArray alloc]init];
    
    self.itineraryTable.delegate = self;
    self.itineraryTable.dataSource = self;
    
    self.itineraryTable.allowsMultipleSelectionDuringEditing = NO;
    self.itineraryTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Pulled user from Firebase");
        } else {
            NSLog(@"Failed to pull user from Firebase");
        }
    }];
    
    [self setUpCoreLocation];
}


#pragma mark - Itineraries Table

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [Constants vikingBlueColor];
    headerView.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5].CGColor;
    headerView.layer.borderWidth = 2.0;
    headerView.layer.cornerRadius = 5.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(2, 0, tableView.frame.size.width -5, 50);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:22.0];
    headerLabel.text = @" Recent Itineraries:";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itineraries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserProfileItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itineraryCell"
                                                                 forIndexPath:indexPath];
    cell.itinerary = self.itineraries[indexPath.row];
    cell.itineraryLabel.text = cell.itinerary.title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Preparing for segue from User Profile");
    
    if ([segue.identifier isEqualToString:@"ItineraryFromUserProfileSegue"]) {
        ItineraryViewController *destinationVC = [segue destinationViewController];
        UserProfileItineraryTableViewCell *cell = sender;
        destinationVC.itinerary = cell.itinerary;
        destinationVC.latitude = self.latitude;
        destinationVC.longitude = self.longitude;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Determine itinerary to be removed
        Itinerary *itinerary = self.itineraries[indexPath.row];
        
        // Remove itinerary from user and itineraries reference
        [FirebaseAPIClient removeItineraryWithItineraryID:itinerary.itineraryID
                                               completion:^(BOOL success) {
            if (success) {
                NSLog(@"Successfully removed itinerary %@ from Firebase", itinerary.itineraryID);
            } else {
                NSLog(@"Failed to remove itinerary %@ from Firebase", itinerary.itineraryID);
            }
        }];
        
        // Remove itinerary from array of itineraries
        [self.itineraries removeObjectAtIndex:indexPath.row];
        
        // Remove cell from table view
        [self.itineraryTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Reload table data
        [self.itineraryTable reloadData];
    }
}


#pragma mark - Pull Info

-(void)pullUserFromFirebaseWithCompletion:(void(^)(BOOL success))completion {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
        
    [FirebaseAPIClient getUserFromFirebaseWithUserID:ref.authData.uid completion:^(User * user, BOOL success) {
        
        self.user = user;
        
        if (success) {
            
            self.usernameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
            self.usernameLabel.text = self.user.username;
            
            self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
            self.userImage.clipsToBounds = YES;
            self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            
            if(![self.user.profilePhoto isEqualToString:@""]){

                [FirebaseAPIClient getImageForImageID:self.user.profilePhoto completion:^(UIImage * image) {
                    self.userImage.image = image;
                }];
                
            } else {
                
                self.userImage.image = [UIImage imageNamed:@"defaultProfilePic"];
            }
            
            [self pullItinerariesForUser];
            
            completion(YES);
            
        } else {
            
            completion(NO);
        }
    }];
}

-(void)pullItinerariesForUser {
    
    NSArray *itineraryIDs = [self.user.savedItineraries allKeys];
    
    self.itineraries = [@[] mutableCopy];
    
    for (NSString *key in itineraryIDs) {
        
        [FirebaseAPIClient getItineraryWithItineraryID:key completion:^(Itinerary * itinerary) {
            [self.itineraries addObject:itinerary];
            [self sortItinerariesByCreationDate];
            [self.itineraryTable reloadData];
        }];
    }
}

-(void)sortItinerariesByCreationDate {
    
    // Sort itineraries by creationDate
    NSMutableArray *temporaryItineraryArray = [self.itineraries mutableCopy];
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"creationDate"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.itineraries = [[temporaryItineraryArray
                         sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}


#pragma mark - Camera and Profile Photo

-(void)setUpCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * noCameraAlert =   [UIAlertController
                                               alertControllerWithTitle:@"Error"
                                               message:@"Device has no camera"
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [noCameraAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [noCameraAlert addAction:ok];
        [self presentViewController:noCameraAlert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.userImage.image = chosenImage;
    
    [FirebaseAPIClient saveProfilePhotoForCurrentUser:chosenImage completion:^(BOOL success) {
        NSLog(@"Success! Profile pic saved");
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)editPictureButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    UIAlertController * editPicture =   [UIAlertController
                                  alertControllerWithTitle:NULL
                                  message:NULL
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"Take new profile photo"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                             [self takeAPictureWithPicker:picker];
                                                         }];
    UIAlertAction* selectPhoto = [UIAlertAction actionWithTitle:@"Select profile photo"
                                                          style: UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                                [self selectAPictureWithPicker:picker];
                                                            }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [editPicture addAction: takePhoto];
    [editPicture addAction: selectPhoto];
    [editPicture addAction: cancel];

    [self presentViewController:editPicture animated:YES completion:nil];
}

-(void)takeAPictureWithPicker:(UIImagePickerController *)picker {
    
    [self setUpCamera];
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController: picker animated:YES completion:NULL];
}

-(void)selectAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController: picker animated:YES completion:NULL];
}


#pragma mark - Core Location

-(void)setUpCoreLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
        
    if (self.mostRecentLocation == nil) {
        self.mostRecentLocation = [locations lastObject];
    }
    
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
    
    if (self.latitude != 0) {
        NSLog(@"Latitude: %f\nLongitude: %f", self.latitude, self.longitude);
    } else {
        NSLog(@"Can't find location");
    }
}

@end
