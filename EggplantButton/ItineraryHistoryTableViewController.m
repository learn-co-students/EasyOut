//
//  ItineraryHistoryTableViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/12/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryHistoryTableViewController.h"
#import "Itinerary.h"
#import "User.h"
#import "Firebase.h"
#import "ItineraryDisplayTableViewCell.h"

@interface ItineraryHistoryTableViewController ()

@end

@implementation ItineraryHistoryTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor clearColor];

    self.itineraryEvents = [NSMutableArray new];
    
    self.titlesOfItineraries = [NSMutableArray new];
    
    
    [self getEventsWithCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
    
    [self getTitlesWithCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.titlesOfItineraries.count;
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
