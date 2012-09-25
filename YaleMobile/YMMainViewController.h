//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *temperature;
@property (nonatomic, strong) IBOutlet UILabel *greeting;
@property (nonatomic, strong) IBOutlet UIImageView *weather;

@property (nonatomic, strong) NSString *name;

@end
