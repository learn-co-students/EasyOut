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

@interface ItineraryHistoryTableViewController ()

@end

@implementation ItineraryHistoryTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return self.titlesOfItineraries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.itineraryEvents.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.titlesOfItineraries[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItineraryCell" forIndexPath:indexPath];
    NSString *singleItineraryName = self.itineraryEvents[indexPath.row];
    cell.textLabel.text = singleItineraryName;

    return cell;
}




-(void)getEventsWithCompletion: (void (^) (BOOL)) completion{
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://easyout.firebaseio.com/itineraries"];
    
    [ref observeSingleEventOfType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {        
        Itinerary *itinerary = [[Itinerary alloc]init];
        itinerary = snapshot.value[@"activities"];
        for (NSString *singleItinerary in itinerary) {
            [self.itineraryEvents addObject:singleItinerary];
        }
        completion(YES);
    }];
}

-(void)getTitlesWithCompletion:(void(^)(BOOL))completion {
    
    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://easyout.firebaseio.com/itineraries"];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        for (FDataSnapshot *childSnapshot in snapshot.children){
            NSString *title = childSnapshot.value[@"title"];
            [self.titlesOfItineraries addObject:title];
        }
        completion(YES);
    }];
}


@end
