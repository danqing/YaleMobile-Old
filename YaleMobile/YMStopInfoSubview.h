//
//  YMStopInfoSubview.h
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMStopInfoSubview : UIView

@property (nonatomic, strong) IBOutlet UILabel *lineName;
@property (nonatomic, strong) IBOutlet UILabel *etaLabel;
@property (nonatomic, strong) IBOutlet UILabel *minutes;
@property (nonatomic, strong) IBOutlet UILabel *stopName;
@property (nonatomic, strong) IBOutlet UILabel *stopCode;

@end
