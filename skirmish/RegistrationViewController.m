//
//  RegistrationViewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Networker.h"
#import "LoginViewController.h"

@interface RegistrationViewController ()


@property (weak, nonatomic) IBOutlet UIPickerView *RolePicker;
@property (weak, nonatomic) IBOutlet UILabel *im;
@property (strong, nonatomic) NSArray *roles;

@property (weak, nonatomic) IBOutlet UITextField *username_input;
@property (weak, nonatomic) IBOutlet UITextField *password_input;
@property (weak, nonatomic) IBOutlet UITextField *city_input;
@property (weak, nonatomic) IBOutlet UITextField *school_input;
@property (weak, nonatomic) IBOutlet UIButton *register_button;


@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.username_input.delegate = self;
    self.password_input.delegate = self;
    self.city_input.delegate = self;
    self.school_input.delegate = self;
    
    self.roles  = [[NSArray alloc]
                   initWithObjects:@"Я ученик!",@"Я преподаватель",@"Я родитель",@"Не скажу" , nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickIM)];
    [self.im addGestureRecognizer:tap];
    self.im.userInteractionEnabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) clickIM
{
    self.RolePicker.hidden = NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)registerButtonClick:(UIButton *)sender
{
    NSString *user = self.username_input.text;
    NSString *pass = self.password_input.text;
    NSString *city = self.city_input.text;
    NSString *school= self.school_input.text;
    
    Networker *net = [[Networker alloc] init];
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           user, @"user",
                           pass, @"pass",
                           city, @"city",
                           school, @"school", nil];
    
    NSDictionary *result = [net post:(NSString *)@"/player/register" : (NSDictionary *) extra];
    
    if ([[result valueForKey:@"status"]  isEqual: @"create"]){
        LoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self presentViewController:loginView animated:YES completion:nil];
    }
    
    if ([[result valueForKey:@"status"]  isEqual: @"exists"]){
        NSLog(@"exists");
    }
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *resultString = self.roles[row];
    
    self.im.text = resultString;
    self.RolePicker.hidden = YES;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component

{
    return [self.roles objectAtIndex:row];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 4;
    
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
