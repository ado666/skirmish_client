//
//  ViewController.m
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView animateWithDuration:2.0 delay:0.2 options:0 animations:^
     {
         CGRect frame = self.imageView.frame;
         frame.origin.y = 15.0;
         self.imageView.frame = frame;
     }
                     completion:^( BOOL completed )
     {
         // По окончанию анимации выполним наш переход к стартовому экрану
         [self performSegueWithIdentifier: @"LoadingSegue" sender: self];
     }];
}

    // Do any additional setup after loading the view, typically from a nib.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
