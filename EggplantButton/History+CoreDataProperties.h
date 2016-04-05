//
//  History+CoreDataProperties.h
//  EggplantButton
//
//  Created by Stephanie on 4/5/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "History.h"

NS_ASSUME_NONNULL_BEGIN

@interface History (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Itinerary *> *itineraries;

@end

@interface History (CoreDataGeneratedAccessors)

- (void)addItinerariesObject:(Itinerary *)value;
- (void)removeItinerariesObject:(Itinerary *)value;
- (void)addItineraries:(NSSet<Itinerary *> *)values;
- (void)removeItineraries:(NSSet<Itinerary *> *)values;

@end

NS_ASSUME_NONNULL_END
