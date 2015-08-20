//
//  ZVListOfEventsCell.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVListOfEventsCell.h"
#import "ZVOpenEvent.h"

@interface ZVListOfEventsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleEventLabel;

@end

@implementation ZVListOfEventsCell

- (void)updateCellWithEvent:(ZVOpenEvent *)event {
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:event.time
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    self.timeEventLabel.text = dateString;
    self.whoLabel.text = event.who;
    self.titleEventLabel.text = event.name;
}

@end
