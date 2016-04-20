//
//  UserProfileViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/13/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "UserProfileViewController.h"


@interface UserProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) User * user;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRatedLabel;
@property (weak, nonatomic) IBOutlet UIStackView *numTipsGivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfItineraries;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)editPictureButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    UIAlertController * editPicture =   [UIAlertController
                                  alertControllerWithTitle:NULL
                                  message:NULL
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                         actionWithTitle:@"Take a New Profile Picture"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self takeAPictureWithPicker:picker];
                         }];
    UIAlertAction* selectPhoto = [UIAlertAction
                                actionWithTitle:@"Select Profile Picture"
                                  style: UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectAPictureWithPicker:picker];
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                             handler:nil];
    [editPicture addAction:takePhoto];
    [editPicture addAction:selectPhoto];
    [editPicture addAction: cancel];

    [self presentViewController:editPicture animated:YES completion:nil];
    
    
}

-(void)takeAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)selectAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}



@end
