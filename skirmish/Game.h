//
//  Game.h
//  skirmish
//
//  Created by Boris Kuznetsov on 13/11/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

- (void) changed :(NSString*) entityId;
- (void) selectTheme :(NSInteger*) themeId;

@property (nonatomic) NSString* status;

@property (nonatomic) NSDictionary* turn;
@property (nonatomic) NSString* step;
@property (nonatomic) NSNumber* gameId;

@property (nonatomic) NSArray* questions;

@property (nonatomic) NSArray* players;
@property (nonatomic) NSArray* rounds;
@property (nonatomic) NSDictionary* current_round;

@end
