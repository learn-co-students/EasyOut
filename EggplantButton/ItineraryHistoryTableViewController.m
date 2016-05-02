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

@property (strong, nonatomic) UIActivityIndicatorView * spinner;


@end

@implementation ItineraryHistoryTableViewController

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
    
    self.itineraries = [[NSMutableArray alloc]init];
    
    self.tableView.delegate = self;
    
    [self addItinerariesToTableView];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    Itinerary *currentItinerary = self.titlesOfItineraries[indexPath.row];
    //    NSLog(@"what is current One: %@", currentItinerary);
    //    cell.textLabel.text = self.titlesOfItineraries[indexPath.row];
    //
    //    NSArray *activities = self.itineraryEvents[indexPath.row];
    //    
    
    return cell;
}

-(void)addItinerariesToTableView {
    
    for (NSString *key in self.itineraryIDs) {
        
        [FirebaseAPIClient getItineraryWithItineraryID:key completion:^(Itinerary * itinerary) {
            [self.itineraries addObject:itinerary];
            [self sortItinerariesByCreationDate];
            [self.tableView reloadData];
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

@end
