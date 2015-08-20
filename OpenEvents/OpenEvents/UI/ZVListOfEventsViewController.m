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
#import <JGProgressHUD.h>

@interface ZVListOfEventsViewController ()

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) JGProgressHUD *progressHUD;

@end

@implementation ZVListOfEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startGetLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    [self.progressHUD showInView:self.view];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZVOpenEvent *event = self.eventsArray[indexPath.row];
    return [ZVListOfEventsCell heightForEvent:event];
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
          
          if (self.progressHUD.visible) {
              [self.progressHUD dismiss];
          }
      } onFailure:^(NSError *error, NSInteger statusCode) {
          [self showAlertError];
      }];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self showAlertError];
    }];
}

- (void)showAlertError {
    
    if (self.progressHUD.visible) {
        [self.progressHUD dismiss];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
