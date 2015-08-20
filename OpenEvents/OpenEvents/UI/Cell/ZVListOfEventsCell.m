//
//  ZVListOfEventsCell.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVListOfEventsCell.h"
#import "ZVOpenEvent.h"
#import <NSDate+MTDates.h>

#define offsetGlobalForTitleLabel 40

@interface ZVListOfEventsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleEventLabel;

@end

@implementation ZVListOfEventsCell

- (void)updateCellWithEvent:(ZVOpenEvent *)event {
    
    NSString *dateStartString = [NSDateFormatter localizedStringFromDate:event.time
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    double duration = [event.duration floatValue] / 1000;
    
    
    NSString *dateEndString = [NSDateFormatter localizedStringFromDate:[event.time mt_dateSecondsAfter:duration]
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterShortStyle];
    
    self.timeEventLabel.text = [NSString stringWithFormat:@"%@ - %@", dateStartString, dateEndString];
    self.whoLabel.text = event.who;
    self.titleEventLabel.text = event.name;
    
    self.titleEventLabel.frame = CGRectMake(CGRectGetMinX(self.titleEventLabel.frame), CGRectGetMinY(self.titleEventLabel.frame), 300, [ZVListOfEventsCell heightForEvent:event] - offsetGlobalForTitleLabel);
}

+ (CGFloat)heightForEvent:(ZVOpenEvent *)event {
    
    CGFloat offset = 10.0;
    
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return (CGRectGetHeight(rect) + 2 * offset) + offsetGlobalForTitleLabel;
}

@end
