//
//  Game.m
//  skirmish
//
//  Created by Boris Kuznetsov on 13/11/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"
#import "AppDelegate.h"
#import "Networker.h"
#import "GameFactory.h"

@interface Game ()
//@property (weak, nonatomic) NSString *name;
//@property (weak, nonatomic) NSString *status;
//@property NSString name;

@end

@implementation Game

- (void) selectTheme:(NSInteger*)themeId{
    NSArray *themes = [self.current_round valueForKey:@"themes"];
    NSDictionary* founded;
    for (id theme in themes){
        if ([[theme objectForKey:@"id"] integerValue] == (int)themeId) {
            founded = theme;
        }
    }
//    NSLog(@" asd %@ %@ ", [founded valueForKey:@"id"], self.gameId);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Networker *net = appDelegate.networker;
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           [[founded valueForKey:@"id"] stringValue], @"theme_id",
                           self.gameId, @"game_id",
                           nil];

    
    [net post:@"/game/theme_select" : extra];
}

- (void) changed:(NSString *)entityId{
    
}

@synthesize current_round = _current_round;
- (void) setCurrent_round:(NSDictionary *)current_round{
    _current_round = current_round;
}
- (NSDictionary*) current_round {
    return _current_round;
}

@synthesize rounds = _rounds;
- (void) setRounds:(NSArray *)rounds{
    _rounds = rounds;
}
- (NSArray*) rounds{
    return _rounds;
}

@synthesize players = _players;
- (void) setPlayers:(NSArray *)players{
    _players = players;
}

- (NSArray*) players {
    return _players;
}

@synthesize status = _status;
- (void) setStatus:(NSNumber*)status {
    _status = status;
}
- (NSNumber*) status {
    return _status;
}

@synthesize turn = _turn;
- (void) setTurn:(NSDictionary*)turn {
    _turn = turn;
}
- (NSDictionary*) turn {
    return _turn;
}

@synthesize gameId = _gameId;
- (void) setGameId:(NSNumber*)gameId {
//    NSLog(@"set game %@", gameId);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GameFactory *gf = appDelegate.gameFactory;
//
    NSDictionary *data = [gf get:gameId];
//
//    NSDictionary *data = [net post:@"/game/get" :[NSDictionary dictionaryWithObjectsAndKeys:gameId, @"entityId", nil]];
    
    [self setPlayers:[data valueForKey:@"players"]];
    [self setRounds:[data valueForKey:@"rounds"]];
    [self setCurrent_round:[data valueForKey:@"current_round"]];
    [self setStatus:[data valueForKey:@"status"]];
    
    _gameId = gameId;
}
- (NSNumber*) gameId {
    return _gameId;
}

@synthesize step = _step;
- (void) setStep:(NSString*)step {
    _step = step;
}
- (NSString*) step {
    return _step;
}

@synthesize questions = _questions;
- (void) setQuestion:(NSArray *)questions {
    _questions = questions;
}
- (NSArray*) question {
    return _questions;
}

@end

