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

//@interface tableViewController : UIViewController <TargetDelegate>
@interface tableViewController : UITableViewController
	<TargetDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfPlacemarks;
@property (strong, nonatomic) NSMutableArray *displayItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editModeButton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

- (IBAction)addPlacemark:(id)sender;
- (IBAction)editButtonClicked:(id)sender;

- (void) saveToPlist;
- (void) loadFromPlist;
@end
