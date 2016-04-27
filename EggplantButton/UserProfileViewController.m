//
//  UserProfileViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/13/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EggplantButton-Swift.h"
#import "Firebase.h"
#import "Secrets.h"
#import "Itinerary.h"
#import "CircleLabelView.h"

@interface UserProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITableView *itineraryTable;

@property (strong, nonatomic) NSMutableArray *itineraries;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.itineraryTable.delegate = self;
    self.itineraryTable.dataSource = self;
    
    [self pullUserFromFirebase];
    
    [self pullItinerariesForUser];
    
    [self setUpCamera];

}

#pragma mark - table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"ITINERARY COUNT: %lu", self.itineraries.count);
    
    return self.itineraries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userProfileCell" forIndexPath:indexPath];
    
    cell.textLabel.text = ((Itinerary *)self.itineraries[indexPath.row]).title;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}





#pragma mark - pull info

-(void)pullUserFromFirebase {
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {
            
            self.usernameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
            self.usernameLabel.text = self.user.username;
            
            
            self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
            self.userImage.clipsToBounds = YES;
            self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            
            if(![self.user.profilePhoto isEqualToString:@""]){
                [FirebaseAPIClient getImageForImageID:self.user.profilePhoto completion:^(UIImage * image) {
                    self.userImage.image =image;
                }];
            }
            
            else {
                self.userImage.image = [UIImage imageNamed:@"defaultProfilePic"];
            }
        }
    }];
}

-(void)pullItinerariesForUser {
    __block NSArray *itineraryIDs = [[NSMutableArray alloc]init];
    
    self.itineraries = [[NSMutableArray alloc]init];
    
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {
            
            itineraryIDs = [self.user.savedItineraries allKeys];
            
            for(NSString *key in itineraryIDs) {
                
                [FirebaseAPIClient getItineraryWithItineraryID:key completion:^(Itinerary * itinerary) {
                    
                    [self.itineraries addObject:itinerary];
                    
                    [self.itineraryTable reloadData];
                    
                }];
                
                
            }
        }
    }];

}

-(void)pullUserFromFirebaseWithCompletion:(void(^)(BOOL success))completion {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    [FirebaseAPIClient getUserFromFirebaseWithUserID:ref.authData.uid completion:^(User * user, BOOL success) {
        
        self.user = user;
        
        completion(YES);
    }];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.userImage.image = chosenImage;
    

    [FirebaseAPIClient saveProfilePhotoForCurrentUser:chosenImage completion:^(BOOL success) {
        NSLog(@"success! profile pic saved");
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
    
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"Take a New Profile Picture"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                             [self takeAPictureWithPicker:picker];
                                                         }];
    UIAlertAction* selectPhoto = [UIAlertAction actionWithTitle:@"Select Profile Picture"
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
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController: picker animated:YES completion:NULL];
    
    
}

-(void)selectAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController: picker animated:YES completion:NULL];
    
}



@end
