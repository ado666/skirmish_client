//
//  AppDelegate.m
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "Networker.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "GameViewController.h"
#import "LobbyViewController.h"

#import "User.h"

#import "GameFactory.h"
#import "Game.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [application registerUserNotificationSettings:mySettings];
    [application registerForRemoteNotifications];

    self.networker  = [[Networker alloc] init];
    self.user       = [[User alloc] init];
    
    self.gameFactory= [[GameFactory alloc] init];
    self.game       = [[Game alloc] init];
    
    [self.user addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([[change valueForKey:@"new"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_OFFLINE]]){
        [self openView:@"LoginView"];
    }
    if ([[change valueForKey:@"new"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_ONLINE]]){
        [self openView:@"LobbyNewView"];
    }
    if ([[change valueForKey:@"new"] isEqualToNumber:[[NSNumber alloc] initWithDouble:PLAYER_STATUS_LOOKING]]){
        [self openView:@"LobbyNewView"];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
//    NSLog(@"My token is: %@", deviceToken);
    self.device_token = deviceToken;
    
    NSString *dtoken = [NSString stringWithFormat:@"%@", self.device_token];
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           dtoken, @"push_id",
                           nil];
    [self.networker post:@"/player/hello" :extra];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) openView:(NSString *) view{
    if ([view isEqualToString: self.current]){
        return;
    }
    self.current = view;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:view];
    
    UINavigationController* navigator = (UINavigationController *)self.window.rootViewController;
    [navigator pushViewController:viewController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    NSLog(@"remote notification %@", userInfo);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    Game *game = appDelegate.game;
    GameFactory *gf = appDelegate.gameFactory;
    
    NSDictionary *data  = [userInfo objectForKey:@"apn"];
    NSArray *changed   = [data valueForKey:@"changed"];
    NSArray *new   = [data valueForKey:@"new"];
    
    for (id item in changed){
        NSString *entity = [item valueForKey:@"entity"];
        NSNumber *entity_id = [item valueForKey:@"entity_id"];
        
        if ([entity isEqualToString:@"user"]){
            [user needUpdate:entity_id];
        }
        if ([entity isEqualToString:@"game"]){
            [gf changed:entity_id];
        }
    }
    
    for (id item in new){
        NSString *entity = [item valueForKey:@"entity"];
        NSNumber *entity_id = [item valueForKey:@"entity_id"];
        
        if ([entity isEqualToString:@"game"]){
            [gf changed:entity_id];
        }
    }
    

//    NSString *action    = [data valueForKey:@"action"];
//    
//    if ([action isEqualToString:@"new_game"]){
//        [self.gameFactory changed:[data valueForKey:@"game_id"]];
//        UIApplicationState state = [application applicationState];;
//        if (state == UIApplicationStateActive) {
//            UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"My Title"
//                                      message:@"Enter User Credentials"
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {}];
//
//            [alert addAction:defaultAction];
//            [self.window.rootViewController presentViewController:alert animated:TRUE completion:nil];
//        }else{
//        }
//    }
//    if ([action isEqualToString:@"refre"]){
//        
//    }
    return;

//    UIApplicationState state = [application applicationState];
//    if (state == UIApplicationStateActive) {
//        NSLog(@"app is opened");
//    } else {
//        NSLog(@"app is closed");
//    }
//    
//    NSDictionary *apn = [userInfo objectForKey:@"apn"];
//    NSLog(@" %@ ", userInfo);
//    NSString *action = [apn valueForKey:@"action"];
//    
//    if ([action isEqualToString:@"enemy_turn"]){
//        [self openView:@"EnemyView"];
//    }else if ([action isEqualToString:@"ingame"]){
//        [self openView:@"GameView"];
//    }else if ([action isEqualToString:@"show_result"]){
//        [self openView:@"ResultView"];
//    }else if ([action isEqualToString:@"new_game"]){
//        NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
//                               [apn valueForKey:@"game_id"], @"game_id",
//                               nil];
//        [self.networker post:@"/game/get" :extra];
//    }
    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GameViewController *gameViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameView"];
//    UINavigationController* navigator = (UINavigationController *)self.window.rootViewController;
//    [navigator pushViewController:gameViewController animated:YES];
    
//    UIViewController *game = [[GameViewController alloc] init];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GameViewController *gameViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameView"];
//    NSLog(@"%@", self.window.rootViewController);
//    [self.window.rootViewController pushViewController:gameViewController animated:YES];
    
    // Call this from the pushed view controller to go back to the original view controller
//    [self.navigationController popViewControllerAnimated:NO];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GameViewController *gameViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameView"];
//    NSLog(@"111 %@", gameViewController);
//    [self.window makeKeyAndVisible];
//    NSLog(@"%@", [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]);
//    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] presentViewController:gameViewController animated:YES completion:NULL];
//    [self.window makeKeyAndVisible];
    
//    NSString *segueId = success ? @"pushMain" : @"pushLogin";
//    [self.window.rootViewController performSegueWithIdentifier:@"GameSegue" sender:self.window.rootViewController];
//    [self.window.rootViewController performSegueWithIdentifier: @"GameSegue" sender: self.window.rootViewController];
//    LoginViewController* login = (LoginViewController*)  self.window.rootViewController;
//    
//    NSLog(@"asd %@", login);
//    LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//    NSLog(@"asd %@", self.loginView);
//    NSLog(@"root %@", self.window.rootViewController);
//    [self.window.rootViewController performSegueWithIdentifier: @"GameSegue" sender: self];
//    [[self window].rootViewController presentViewController:self.registrationView animated:YES completion:nil];
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    UIViewController *root = [window rootViewController];
    
//    self.window.rootViewController = self.gameView;
//    [self.window makeKeyAndVisible];
//    
//    [(UINavigationController *)self.window.rootViewController pushViewController:self.gameView animated:NO];

    
//    UIStoryboard *storyboard = root.storyboard;
//    LobbyViewController *lobbyView =(LobbyViewController *) [storyboard instantiateViewControllerWithIdentifier:@"LobbyView"];
    
//        LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//        [self presentViewController:loginView animated:YES completion:nil];
//    LobbyViewController *lobbyView = self.;
    
//    [lobbyView to_game];

    //    LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//    [self presentViewController:loginView animated:YES completion:nil];
//    [navController.visibleViewController.navigationController pushViewController:notificationViewController];
}

@end
