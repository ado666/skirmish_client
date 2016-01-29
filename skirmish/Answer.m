//
//  Answer.m
//  skirmish
//
//  Created by Boris Kuznetsov on 25/01/16.
//  Copyright © 2016 Boris Kuznetsov. All rights reserved.
//

#import "Answer.h"
#import "AppDelegate.h"
#import "Game.h"
#import "User.h"
#import "Networker.h"


@interface Answer ()

@property (weak, nonatomic) IBOutlet UILabel *question;

@property (weak, nonatomic) IBOutlet UILabel *answer1;
@property (weak, nonatomic) IBOutlet UILabel *answer2;
@property (weak, nonatomic) IBOutlet UILabel *answer3;
@property (weak, nonatomic) IBOutlet UILabel *answer4;

@end


@implementation Answer

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    [game addObserver:self forKeyPath:@"current_round" options:NSKeyValueObservingOptionNew context:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    [game removeObserver:self forKeyPath:@"current_round"];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;

    NSDictionary *cr = [game valueForKey:@"current_round"];
    NSArray *qs = [cr valueForKey:@"questions"];
    
    NSDictionary *cq = [qs objectAtIndex: [[cr valueForKey:@"step"] integerValue]-1];
    
    self.question.text = [cq valueForKey:@"question"];
    self.answer1.text = [cq valueForKey:@"answer1"];
    self.answer2.text = [cq valueForKey:@"answer2"];
    self.answer3.text = [cq valueForKey:@"answer3"];
    self.answer4.text = [cq valueForKey:@"answer4"];
    
    UIGestureRecognizer *answer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAnswer1:)];
    UIGestureRecognizer *answer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAnswer2:)];
    UIGestureRecognizer *answer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAnswer3:)];
    UIGestureRecognizer *answer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAnswer4:)];
    //
    [self.answer1 addGestureRecognizer: answer1];
    [self.answer2 addGestureRecognizer: answer2];
    [self.answer3 addGestureRecognizer: answer3];
    [self.answer4 addGestureRecognizer: answer4];
    
//    NSLog(@"status %@", [cr valueForKey:@"step"]);
    
//    [game addObserver:self forKeyPath:@"current_round" options:NSKeyValueObservingOptionNew context:nil];

    
//    UIGestureRecognizer *answerHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAnswer:)];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Game *game = appDelegate.game;
    User *user = appDelegate.user;
    
    if ([keyPath isEqualToString:@"current_round"]) {
        NSDictionary *cr = [change valueForKey:@"new"];
//        NSLog(@"status %@", [cr valueForKey:@"step"]);
//        if ([data objectForKey:@"theme"] != NULL){
//            [self.selectTheme setHidden:YES];
//            [self.Answer setHidden:NO];
//        }else{
//            [self.selectTheme setHidden:NO];
//            [self.Answer setHidden:YES];
//        }
        
//        NSDictionary *cr = [game valueForKey:@"current_round"];
        NSArray *qs = [cr valueForKey:@"questions"];
        
        NSDictionary *cq = [qs objectAtIndex: [[cr valueForKey:@"step"] integerValue]-1];
        
        self.question.text = [cq valueForKey:@"question"];
        self.answer1.text = [cq valueForKey:@"answer1"];
        self.answer2.text = [cq valueForKey:@"answer2"];
        self.answer3.text = [cq valueForKey:@"answer3"];
        self.answer4.text = [cq valueForKey:@"answer4"];
    }
}


- (void) doAnswer: (NSInteger) choice {
//    NSLog(@"tap %ld", (long)choice);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Networker *net = appDelegate.networker;
    Game *game = appDelegate.game;
    
    NSDictionary *extra = [NSDictionary dictionaryWithObjectsAndKeys:
                           game.gameId, @"game_id", nil];
//                            (long)choice, @"choice", nil];
    
    [net post:@"/game/answer" :extra];
}
- (void) doAnswer1: (UIGestureRecognizer*) recognizer {
    [self doAnswer:1];
}
- (void) doAnswer2: (UIGestureRecognizer*) recognizer {
    [self doAnswer:2];
}
- (void) doAnswer3: (UIGestureRecognizer*) recognizer {
    [self doAnswer:3];
}
- (void) doAnswer4: (UIGestureRecognizer*) recognizer {
    [self doAnswer:4];
}

- (IBAction)clickAnswer:(UITapGestureRecognizer *)sender {
//    NSLog(@"aasdddsa");
}


@end
