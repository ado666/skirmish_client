//
//  LobbyViewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 06/10/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "LobbyViewController.h"
#import "GameViewController.h"
#import "Networker.h"
#import "AppDelegate.h"
#import "User.h"

@interface LobbyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name_text;
@property (weak, nonatomic) IBOutlet UILabel *status_text;
@property (weak, nonatomic) IBOutlet UIButton *find_enemy_button;
@property (weak, nonatomic) IBOutlet UIButton *logout;

@end

@implementation LobbyViewController

- (id) init {
    return self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = appDelegate.user;
    
    [user addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"The name of the child was changed.");
        NSLog(@"%@", change);
    }
    
    if ([keyPath isEqualToString:@"age"]) {
        NSLog(@"The age of the child was changed.");
        NSLog(@"%@", change);
    }
    
}

- (IBAction)logout:(id)sender {
    UIApplication *app = [[UIApplication sharedApplication] delegate];
    Networker *net = [app valueForKey:@"networker"];
    
    [net post:@"/player/logout" :[[NSDictionary alloc] init]];
}

- (IBAction)subscribe:(id)sender {
    UIApplication *app = [[UIApplication sharedApplication] delegate];
    Networker *net = [app valueForKey:@"networker"];

    if ([self.find_enemy_button.currentTitle isEqualToString:@"Отмена"]){
        NSDictionary *extra = [[NSDictionary alloc] init];
        
        NSDictionary *result = [net post:(NSString *)@"/player/unsubscribe" : (NSDictionary *) extra];
        
        if ([[result valueForKey:@"status"] isEqualToString:@"redirect_login"]){
            [self performSegueWithIdentifier: @"BackLoginSegue" sender: self];
        }
        
        if ([[result valueForKey:@"status"] isEqualToString:@"ok"]){
            self.status_text.text = @"Normal";
            [self.find_enemy_button setTitle:@"Поиск соперника" forState:UIControlStateNormal];
        }

    }else{
        NSDictionary *extra = [[NSDictionary alloc] init];
    
        NSDictionary *result = [net post:(NSString *)@"/player/subscribe" : (NSDictionary *) extra];
    
        if ([[result valueForKey:@"status"] isEqualToString:@"redirect_login"]){
            [self performSegueWithIdentifier: @"BackLoginSegue" sender: self];
        }
    
        if ([[result valueForKey:@"status"] isEqualToString:@"ok"]){
            self.status_text.text = @"Looking...";
            [self.find_enemy_button setTitle:@"Отмена" forState:UIControlStateNormal];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    NSLog(@"asd %@", [appDelegate.user getUsername]);
    self.name_text.text = appDelegate.user.login;
//    self.status_text.text = appDelegate.user.status;
    
//    if ([appDelegate.user.status isEqualToString:@"online"]){
//        [self.find_enemy_button setTitle:@"Поиск соперника" forState:UIControlStateNormal];
//    }else{
//        [self.find_enemy_button setTitle:@"Отмена" forState:UIControlStateNormal];
//    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) to_game {
//    LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//    [self presentViewController:loginView animated:YES completion:nil];
//    [self performSegueWithIdentifier: @"GameSegue" sender: self];
//    [self.windows makeKeyAndVisible];
//    GameViewController *gameView = [self.storyboard instantiateViewControllerWithIdentifier:@"GameView"];
//    [self presentViewController:gameView animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
