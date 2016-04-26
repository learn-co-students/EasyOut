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


@interface ItineraryHistoryTableViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItineraryCell" forIndexPath:indexPath];
    
    //    Itinerary *currentItinerary = self.titlesOfItineraries[indexPath.row];
    //    NSLog(@"what is current One: %@", currentItinerary);
    //    cell.textLabel.text = self.titlesOfItineraries[indexPath.row];
    //
    //    NSArray *activities = self.itineraryEvents[indexPath.row];
    //    
    
    return cell;
}
@end
