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

@end
