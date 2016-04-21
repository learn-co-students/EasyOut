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
#import "CircleLabelView.h"

@interface UserProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) User * user;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet CircleLabelView *tipsLabel;
@property (weak, nonatomic) IBOutlet CircleLabelView *ratedLabel;
@property (weak, nonatomic) IBOutlet CircleLabelView *itineraryLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {
            
            self.usernameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
            self.usernameLabel.text = self.user.username;
            
            self.bioLabel.text = self.user.bio;
            
            self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
            self.userImage.clipsToBounds = YES;
            self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            
            self.tipsLabel.type = Tips;
            self.ratedLabel.type = Ratings;
            self.itineraryLabel.type = Itineraries;
            
            [self.tipsLabel createCircleLabel];
            [self.ratedLabel createCircleLabel];
            [self.itineraryLabel createCircleLabel];
        }
    }];
    [self setUpCamera];

    
    self.view.contentMode = UIViewContentModeCenter;
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"city"]]];

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
