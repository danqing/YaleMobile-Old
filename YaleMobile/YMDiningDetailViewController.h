//
//  YMDiningDetailViewController.h
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDiningDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *abbr;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic) NSInteger locationID;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
