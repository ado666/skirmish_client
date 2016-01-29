//
//  AppDelegate.h
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networker.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "GameViewController.h"
#import "LobbyViewController.h"

#import "User.h"

#import "GameFactory.h"
#import "Game.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Networker *networker;
@property (strong, nonatomic) LoginViewController *loginView;
@property (strong, nonatomic) RegistrationViewController *registrationView;
@property (strong, nonatomic) LobbyViewController *lobbyView;
@property (strong, nonatomic) GameViewController *gameView;
@property (strong, nonatomic) NSData *device_token;

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) GameFactory *gameFactory;
@property (strong, nonatomic) Game *game;

- (void) openView :(NSString*)view;

@property (strong, nonatomic) NSString *current;

@end

