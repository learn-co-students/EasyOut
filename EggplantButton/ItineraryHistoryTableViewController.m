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
#import "Secrets.h"
#import "HistoryTableViewCell.h"
#import "ItineraryViewController.h"


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
    self.tableView.dataSource = self;
    
    [self addItinerariesToTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itineraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itineraryCell"
                                                                 forIndexPath:indexPath];
    
    cell.itineraryLabel.text = ((Itinerary *)self.itineraries[indexPath.row]).title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.itinerary = self.itineraries[indexPath.row];
    
    return cell;
}

-(void)addItinerariesToTableView {
    
    [FirebaseAPIClient getMostRecentItinerariesWithCompletion:^(NSArray<Itinerary *> * _Nullable itineraries) {
        self.itineraries = (NSMutableArray *)itineraries;
        [self.tableView reloadData];
    }];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Preparing for segue from User Profile");
    
    if ([segue.identifier isEqualToString:@"ItineraryFromUserProfileSegue"]) {
        ItineraryViewController *destinationVC = [segue destinationViewController];
        HistoryTableViewCell *cell = sender;
        destinationVC.itinerary = cell.itinerary;
        destinationVC.latitude = self.latitude;
        destinationVC.longitude = self.longitude;
    }
}


@end
