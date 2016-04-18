//
//  Tip.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Tip.h"

@implementation Tip

// THIS IS NOT AN APPROPRIATE INIT METHOD FOR CREATING A NEW TIP
-(instancetype) initWithUserID:(NSString *)userID tipID:(NSString *)tipID tipText:(NSString *)tipText tipVotes:(NSInteger)tipVotes {
    self = [super init];
    
    if (self) {
        _userID = self.userID;
        _tipID = self.tipID;
        _tipID = self.tipID;
        _tipText = self.tipText;
        _tipVotes = self.tipVotes;
        _creationDate = [NSDate date];
    }
    
    return self;
}

@end
