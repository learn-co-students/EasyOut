//
//  MasterDataStore.h
//  EggplantButton
//
//  Created by Stephanie on 4/5/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "Itinerary.h"

@interface MasterDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSArray *itineraries;

+ (instancetype) sharedHistoryDataStore;

- (void) saveContext;
- (void) generateTestData;
- (void) fetchData;

@end
