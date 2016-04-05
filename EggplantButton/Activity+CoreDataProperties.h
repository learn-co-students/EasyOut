//
//  Activity+CoreDataProperties.h
//  EggplantButton
//
//  Created by Stephanie on 4/5/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Activity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Activity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) Itinerary *itinerary;

@end

NS_ASSUME_NONNULL_END
