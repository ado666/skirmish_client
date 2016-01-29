//
//  RegistrationViewController.h
//  skirmish
//
//  Created by Boris Kuznetsov on 29/09/15.
//  Copyright © 2015 Boris Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

- (IBAction)registerButtonClick:(UIButton *)sender;

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component;


@end