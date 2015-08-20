//
//  ViewController.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVListOfEventsViewController.h"
#import "ZVListOfEventsCell.h"
#import "ZVLocationManager.h"
#import "ZVServerManager.h"
#import "ZVCategory.h"

@interface ZVListOfEventsViewController ()

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZVListOfEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startGetLocation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *simpleTableIdentifier = NSStringFromClass([ZVListOfEventsCell class]);
    ZVListOfEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    ZVOpenEvent *event = self.eventsArray[indexPath.row];
    [cell updateCellWithEvent:event];
    
    return cell;
}

- (void)startGetLocation {
 
    __weak typeof(self) wself = self;
    
    [[ZVLocationManager sharedManager] findCurrentUserLocationSuccess:^(CLLocation *location) {
        
        if (!wself.location) {
            wself.location = location;
            [self loadCategories];
        }
    }];
}

- (void)loadCategories {
    
    [[ZVServerManager sharedManager] getListCategoriesonSuccess:^(NSArray *categories) {
        
        ZVCategory *category = [ZVCategory findTechCategoryInArray:categories];
        
      [[ZVServerManager sharedManager] getListOpenEventsWithCategoryID:[NSString stringWithFormat:@"%@", category.identifier] andLocation:self.location andSuccess:^(NSArray *openEvents) {
          
          self.eventsArray = openEvents;
          [self.tableView reloadData];
          
      } onFailure:^(NSError *error, NSInteger statusCode) {
          [self showAlertError];
      }];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self showAlertError];
    }];
}

- (void)showAlertError {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
