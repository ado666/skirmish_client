//
//  GameFactory.m
//  skirmish
//
//  Created by Boris Kuznetsov on 02/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "GameFactory.h"
#import "AppDelegate.h"

@implementation GameFactory

- (id) init {
    self = [super init];
    
    self.url    = @"/game/get";
    
    return self;
}

- (void) changed:(NSNumber *)entityId{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    Networker *net          = appDelegate.networker;
    
    NSString* ent = [[NSString alloc] initWithFormat:@"%@", entityId];
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           ent, @"entityId",
                           nil];
    
    NSDictionary *result    = [net get:self.url :extra];
    
    [self.entities setObject:[result valueForKey:@"entity"] forKey:ent];
    
//    NSLog(@" %@ %@", entityId, game.gameId);
    if ([entityId integerValue] == [game.gameId integerValue]){
//        NSLog(@"eqal");
        game.gameId = entityId;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"entities" object:nil];
}

@end
