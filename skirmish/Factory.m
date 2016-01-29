//
//  Factory.m
//  skirmish
//
//  Created by Boris Kuznetsov on 02/12/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "Factory.h"

#import "AppDelegate.h"
#import "Networker.h"

@implementation Factory

@synthesize entities= _entities;

- (id) init{
    self.entities = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (NSDictionary*) get:(NSNumber *)entityId{
    NSDictionary *game;
    for (id object in self.entities) {
        if ([[self.entities valueForKey:object] valueForKey:@"id"] == entityId){
            game = [self.entities valueForKey:object];
        }
    }
    
    return game;
}

- (void) all: (NSArray*)data {
    for (id game in data){
        [self.entities setObject:game forKey:[game valueForKey:@"id"]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"entities" object:nil];
}

- (void) changed:(NSNumber *)entityId{
    UIApplication *app      = [[UIApplication sharedApplication] delegate];
    Networker *net          = [app valueForKey:@"networker"];
    
    NSString* ent = [[NSString alloc] initWithFormat:@"%@", entityId];
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           ent, @"entityId",
                           nil];
    
    NSDictionary *result    = [net get:self.url :extra];
    
    [self.entities setObject:[result valueForKey:@"entity"] forKey:ent];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"entities" object:nil];
}

@end
