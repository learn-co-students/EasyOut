//
//  Tip.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *tipID;
@property (strong, nonatomic) NSString *tipText;
@property (nonatomic) NSInteger tipVotes;

-(instancetype) initWithUserID:(NSString *)userID tipID:(NSString *)tipID tipText:(NSString *)tipText tipVotes:(NSInteger)tipVotes;

@end
