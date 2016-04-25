//
//  ItineraryHistoryTableViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/12/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryHistoryTableViewController.h"
#import "EggplantButton-Swift.h"
#import "Itinerary.h"
#import "User.h"
#import "Firebase.h"
#import "ItineraryDisplayTableViewCell.h"
#import "Secrets.h"


@interface ItineraryHistoryTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *itineraryIDs;
@property (strong, nonatomic) NSMutableArray *itineraries;


@end

@implementation ItineraryHistoryTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.itineraries = [[NSMutableArray alloc]init];

    self.tableView.delegate = self;

    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {

            self.itineraryIDs = [self.user.savedItineraries allKeys];

            for(NSString *key in self.itineraryIDs) {

                [FirebaseAPIClient getItineraryWithItineraryID:key completion:^(Itinerary * itinerary) {

                    NSLog(@"%@", itinerary);

                    NSLog(@"%lu", (unsigned long)itinerary.activities.count);

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itineraryIDs.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ItineraryDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItineraryCell" forIndexPath:indexPath];

    Itinerary *currentItinerary = self.titlesOfItineraries[indexPath.row];
    NSLog(@"what is currentOne: %@", currentItinerary);
    cell.titleOfItineraryLabel.text = self.titlesOfItineraries[indexPath.row];

    NSArray *activities = self.itineraryEvents[indexPath.row];


    if (activities.count > 0) {
        cell.activityOneLabel.text = activities[0];
    }
    if (activities.count > 1) {
        cell.activityTwoLabel.text = activities[1];
    }
    if (activities.count > 2) {
        cell.ActivityThreeLabel.text = activities[2];
    }

    return cell;
}


-(void)getEventsWithCompletion: (void (^) (BOOL)) completion {
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://easyout.firebaseio.com/itineraries"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        for (NSString *key in snapshot.value) {
            NSDictionary *dictionary = snapshot.value[key];
            NSArray *activities = dictionary[@"activities"];
            [self.itineraryEvents addObject:activities];
            completion(YES);
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}


-(void)getTitlesWithCompletion:(void(^)(BOOL))completion {

    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://easyout.firebaseio.com/itineraries"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        for (NSString *key in snapshot.value) {
            NSLog(@"Key: %@",key);

            NSDictionary *dictionary = snapshot.value[key];
            NSLog(@"Contents: %@",dictionary);

            NSString *itineraryNames = dictionary[@"title"];
            NSLog(@"Title: %@",itineraryNames);

            [self.titlesOfItineraries addObject:itineraryNames];

            completion(YES);
        }

    } withCancelBlock:^(NSError *error) {
        NSLog(@"****Error: %@", error.description);
    }];
}

@end
