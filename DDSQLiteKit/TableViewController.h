//
//  TableViewController.h
//  DDSQLiteKit
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

extern char * const ddkit_db_queue_name;

extern dispatch_queue_t ddkit_db_read_queue();
    

@interface TableViewController : UITableViewController

@end
