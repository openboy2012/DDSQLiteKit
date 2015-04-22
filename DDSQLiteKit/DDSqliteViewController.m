//
//  DDSqliteViewController.m
//  DDKit
//
//  Created by Diaoshu on 14-12-21.
//  Copyright (c) 2014年 Dejohn Dong. All rights reserved.
//

#import "DDSqliteViewController.h"
#import "SQLiteInstanceManager.h"
#import "Device.h"

#import <LocalAuthentication/LocalAuthentication.h>

#define number 30
#define isUseFMDB 0

@interface DDSqliteViewController (){
    NSTimer *timer;
    NSInteger time;
    
}

@property (nonatomic, weak) IBOutlet UILabel *lblTimer;
@property (nonatomic, weak) IBOutlet UILabel *lblResult;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation DDSqliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SQLiteSave";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SQLiteInstanceManager sharedManager] vacuum];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentControlChanged:(id)sender{
    if(self.segmentedControl.selectedSegmentIndex == 0){
        [self saveDB];
    }else if(self.segmentedControl.selectedSegmentIndex == 3){
        [self queryDB];
    }else if (self.segmentedControl.selectedSegmentIndex == 1){
        [self deleteDB];
    }else if (self.segmentedControl.selectedSegmentIndex == 2){
        [self updateDB];
    }
}

#pragma mark - Custom Methods

- (void)refreshTimer{
    self.lblTimer.text = [NSString stringWithFormat:@"Timer:%.2fs",time/100.0];
    time++;
}

- (void)saveDB{
    [self timerStart];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        for (int i = 0 ; i < number; i++) {
            Device *p = [[Device alloc] init];
            p.name = [NSString stringWithFormat:@"iPhone %d",i];
            p.modelName = [NSString stringWithFormat:@"ME2814/%d",i];
            p.price = @(i);
            p.system = [NSString stringWithFormat:@"iOS%d",i];
            [p save];
        }
        [[SQLiteInstanceManager sharedManager] vacuum];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"success add %d datas",number];
        });
    });
}

- (void)queryDB{
    [self timerStart];
    [Device queryByCriteria:nil result:^(id data) {
        if([data isKindOfClass:[NSArray class]]){
            NSArray *list = data;
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"success query %lu datas",[list count]];
        }else{
            
        }
    }];
}

- (void)deleteDB{
    [self timerStart];
    [Device queryByCriteria:@"WHERE price = '15';" result:^(id data) {
        if([data isKindOfClass:[NSArray class]]){
            NSArray *list = data;
            for (Device *d in list) {
                [d asynDeleteObjectCascade:YES];
            }
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"success delete %lu datas",[list count]];
        }
    }];
}

- (void)updateDB{
    [self timerStart];
    [Device queryByCriteria:@"WHERE price = '10';" result:^(id data) {
        if([data isKindOfClass:[NSArray class]]){
            NSArray *list = data;
            for (Device *d in list) {
                d.price = @(13);
                [d save];
            }
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"success update %lu datas",[list count]];
        }
        [[SQLiteInstanceManager sharedManager] executeUpdateSQL:@"DELETE FROM Device;"];
    }];
}

- (IBAction)clearDB:(id)sender{
    [[SQLiteInstanceManager sharedManager] deleteDatabase];
}

- (void)timerStart{
    [self timerEnd];
    time = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1/100.0f target:self selector:@selector(refreshTimer) userInfo:nil repeats:YES];
}

- (void)timerEnd{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}

@end
