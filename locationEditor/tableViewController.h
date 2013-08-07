//
//  tableViewController.h
//  locationEditor
//
//  Created by laudmankimo on 13-6-14.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "TargetViewController.h"

@interface tableViewController : UITableViewController <TargetDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfPlacemarks;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editModeButton;

- (IBAction)addPlacemark:(id)sender;
- (IBAction)editButtonClicked:(id)sender;

- (void) saveToPlist;
- (void) loadFromPlist;
@end
