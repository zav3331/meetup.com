//
//  ZVListOfEventsCell.h
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZVOpenEvent;

@interface ZVListOfEventsCell : UITableViewCell

- (void)updateCellWithEvent:(ZVOpenEvent *)event;

+ (CGFloat)heightForEvent:(ZVOpenEvent *)event;

@end
