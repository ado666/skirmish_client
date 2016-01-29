//
//  LoginViewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "LoginViewController.h"
#import "Networker.h"
#import "LobbyViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username_input;
@property (weak, nonatomic) IBOutlet UITextField *password_input;
@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (weak, nonatomic) IBOutlet UIButton *register_button;

@property (weak, nonatomic) NSDictionary *for_send;

@end

@implementation LoginViewController

- (IBAction)login:(id)sender {
    UIApplication *app = [[UIApplication sharedApplication] delegate];
    Networker *net = [app valueForKey:@"networker"];
    
    NSString *user = self.username_input.text;
    NSString *pass = self.password_input.text;
    
    NSString *dtoken = [NSString stringWithFormat:@"%@", [app valueForKey:@"device_token"]];
    
//    NSLog(@"dtoken: %@", [app valueForKey:@"device_token"]);
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           user, @"user",
                           pass, @"pass",
                           dtoken, @"push_id",
                           nil];
    
    [net post:(NSString *)@"/player/login" : (NSDictionary *) extra];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"LoginSeague"]){
//        UIApplication *app = [[UIApplication sharedApplication] delegate];
        LobbyViewController *lobby =[self.storyboard instantiateViewControllerWithIdentifier:@"LobbyView"];
//        LobbyViewController *lobby = [app valueForKey:@"lobbyView"];
        lobby.name = [self.for_send valueForKey:@"username"];
        lobby.status = [self.for_send valueForKey:@"status"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"initiate");
    
//    NSLog(@"dsa %@", self);
    
//    UIApplication *app = [[UIApplication sharedApplication] delegate];
//    NSLog(@"%@", [app valueForKey:@"networker"]);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
