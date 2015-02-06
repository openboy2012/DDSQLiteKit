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
    
//    FMDatabase *db;
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
    }
}

#pragma mark - Custom Methods

- (void)refreshTimer{
    self.lblTimer.text = [NSString stringWithFormat:@"计时:%.2fs",time/100.0];
    time++;
}

- (void)saveDB{
    [self timerStart];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        for (int i = 0 ; i < number; i++) {
            Device *p = [[Device alloc] init];
            p.name = [NSString stringWithFormat:@"iPhone %d",i];
            p.model = [NSString stringWithFormat:@"ME2814/%d",i];
            p.price = @(1999);
            [p save];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"成功插入了%d条数据",number];
        });
    });
}

- (void)queryDB{
    [self timerStart];
//    NSDictionary *params = @{@"type":@(DBDataTypeFirstItem),@"criteria":[NSString stringWithFormat:@"WHERE pk = %d", rand()%10000]};
////    NSDictionary *params = nil;
    [Device queryByCriteria:nil result:^(id data) {
        if([data isKindOfClass:[NSArray class]]){
            NSArray *list = data;
            [self timerEnd];
            self.lblResult.text = [NSString stringWithFormat:@"成功查询了%lu条数据",[list count]];
        }else{
//            [self timerEnd];
//            Post *p = data;
//            NSLog(@"post's name = %@ & text = %@ pk＝%d",p.id,p.text,p.pk);
        }
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
