//
//  User.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

-(instancetype) initWithEmail:(NSString *)email
                     password:(NSString *)password;

-(instancetype) initWithUniqueID:(NSString *)uniqueID;

@end
