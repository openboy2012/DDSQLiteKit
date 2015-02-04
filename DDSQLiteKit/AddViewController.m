//
//  ViewController.m
//  DDSQLiteKit
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AddViewController.h"
#import "Device.h"

@interface AddViewController (){
    Device *device;
}

@property (nonatomic, weak) IBOutlet UITextField *tfName;
@property (nonatomic, weak) IBOutlet UITextField *tfModel;
@property (nonatomic, weak) IBOutlet UITextField *tfPrice;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    device = self.params[@"device"];
    if(!device)
        device = [[Device alloc] init];
    else{
        self.tfModel.text = device.model;
        self.tfName.text = device.name;
        self.tfPrice.text = [NSString stringWithFormat:@"%@",device.price];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)add:(id)sender{
    device.name = self.tfName.text;
    device.model = self.tfModel.text;
    device.price = @([self.tfPrice.text integerValue]);
    [device save];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
