//
//  ItineraryViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/19/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryViewController.h"

@interface ItineraryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itineraryTableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itinerary.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    

    
    return cell;
}


@end
