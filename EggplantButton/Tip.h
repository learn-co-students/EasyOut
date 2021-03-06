//
//  Tip.h
//  EasyOut
//
//  Created by Ian Alexander Rahman on 4/11/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *tipID;
@property (strong, nonatomic) NSString *tipText;
@property (nonatomic) NSInteger tipVotes;
@property (strong, nonatomic) NSDate *creationDate;

-(instancetype) initWithUserID:(NSString *)userID tipID:(NSString *)tipID tipText:(NSString *)tipText tipVotes:(NSInteger)tipVotes;

@end
