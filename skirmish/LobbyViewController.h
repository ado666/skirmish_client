//
//  LobbyViewController.h
//  skirmish
//
//  Created by Boris Kuznetsov on 06/10/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "ViewController.h"

@interface LobbyViewController : UIViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;

- (void) to_game;


@end
