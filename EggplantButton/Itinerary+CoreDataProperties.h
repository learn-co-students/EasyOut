//
//  Itinerary+CoreDataProperties.h
//  EggplantButton
//
//  Created by Stephanie on 4/5/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Itinerary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSSet<Activity *> *activities;

@end

@interface Itinerary (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(Activity *)value;
- (void)removeActivitiesObject:(Activity *)value;
- (void)addActivities:(NSSet<Activity *> *)values;
- (void)removeActivities:(NSSet<Activity *> *)values;

@end

NS_ASSUME_NONNULL_END
