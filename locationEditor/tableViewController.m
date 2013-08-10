//
//  tableViewController.m
//  locationEditor
//
//  Created by laudmankimo on 13-6-14.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import "tableViewController.h"

@interface tableViewController ()

@end

@implementation tableViewController
@synthesize arrayOfPlacemarks, displayItems;

#pragma mark - view lifecycles
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self)
    {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    arrayOfPlacemarks = [[NSMutableArray alloc]init];   // 0 objects
    [self loadFromPlist];
	if ([arrayOfPlacemarks count] != 0)
		displayItems = [[NSMutableArray alloc]initWithArray:arrayOfPlacemarks];
	else
		displayItems = [[NSMutableArray alloc]init];	// 0 objects;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [arrayOfPlacemarks count];
	return [displayItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

//    Place *place = [arrayOfPlacemarks objectAtIndex:(NSUInteger) indexPath.row];
    Place *place = [displayItems objectAtIndex:(NSUInteger) indexPath.row];

    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.description;

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
		// 1. get the object
		Place *place = [displayItems objectAtIndex:(NSUInteger) indexPath.row];
		// 2. then just remove the object, don't care about its real position in array
		[arrayOfPlacemarks removeObject:place];
		[displayItems removeObject:place];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [self saveToPlist];
    }
    // else if (editingStyle == UITableViewCellEditingStyleInsert)
    // {
    //  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    // }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Place *place = [arrayOfPlacemarks objectAtIndex:(NSUInteger)fromIndexPath.row];

    [arrayOfPlacemarks removeObjectAtIndex:(NSUInteger)fromIndexPath.row];
    [arrayOfPlacemarks insertObject:place atIndex:(NSUInteger)toIndexPath.row];

    [self saveToPlist];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
	if ([self.mySearchBar.text length] != 0)
		return NO; // when in filter mode, it does not permit rearrange the table's row
	else
		return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    //     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // Pass the selected object to the new view controller.
    //     [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)addPlacemark:(id)sender
{
    TargetViewController *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TargetViewController"];

    targetVC.delegate = self;

    //	[self presentViewController:targetVC animated:YES completion:nil];
    [self.navigationController pushViewController:targetVC animated:YES];
}

- (IBAction)editButtonClicked:(id)sender
{
    static BOOL editMode = YES;
    if ([arrayOfPlacemarks count] == 0)
    {
        return;
    }

    if (editMode)
    {
		editMode = NO;
        [self.tableView setEditing:NO animated:YES];
        self.editModeButton.title = @"编辑";
    }
    else
    {
		editMode = YES;
        [self.tableView setEditing:YES animated:YES];
        self.editModeButton.title = @"完成";
    }
}

- (void)passItemBack:(TargetViewController *)controller PinCoordinate:(CLLocationCoordinate2D)coordinate AnnotationName:(NSString *)name AnnotationDesc:(NSString *)desc
{
    Place *newPlace = [[Place alloc]init];

    newPlace.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    newPlace.longitude = [NSNumber numberWithDouble:coordinate.longitude];
    newPlace.name = name;
    newPlace.description = desc;

    [arrayOfPlacemarks addObject:newPlace];
	[displayItems addObject:newPlace];
    [self saveToPlist];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
	[self setEditModeButton:nil];
	[self setMySearchBar:nil];
    [super viewDidUnload];
}

- (void)saveToPlist
{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"data.plist"];

    NSMutableArray *saveDataArray = [[NSMutableArray alloc]init];       // 0 object

    for (Place *places in arrayOfPlacemarks)
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[places.name, places.description, places.latitude, places.longitude] forKeys:@[@"name", @"desc", @"latitude", @"longitude"]];
        [saveDataArray addObject:dictionary];
    }

    [saveDataArray writeToFile:filePath atomically:YES];
    [saveDataArray removeAllObjects];
}

- (void)loadFromPlist
{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"data.plist"];

    NSArray *dataArray = [[NSArray alloc]initWithContentsOfFile:filePath];

    if (dataArray == nil)
    {
        return;
    }

    if ([dataArray count] == 0)
    {
        return;
    }

    Place *place = nil;
    [arrayOfPlacemarks removeAllObjects];       // force empty

    for (NSDictionary *dict in dataArray)
    {
        place = [[Place alloc]init];
        place.name = [dict objectForKey:@"name"];
        place.description = [dict objectForKey:@"desc"];
        place.latitude = [dict objectForKey:@"latitude"];
        place.longitude = [dict objectForKey:@"longitude"];
        [arrayOfPlacemarks addObject:place];
    }
}

#pragma mark - UISearchBarDelegate function

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = nil;
	[searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//	searchBar.text = nil;
	[searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText length] == 0)
	{
		[displayItems removeAllObjects];
		[displayItems addObjectsFromArray:arrayOfPlacemarks];
	}
	else
	{
		[displayItems removeAllObjects];
		for (Place *place in arrayOfPlacemarks)
		{
			NSRange r = [place.name rangeOfString:searchText options:NSCaseInsensitiveSearch];	// filter by name

			if (r.location != NSNotFound)
			{
				[displayItems addObject:place];
				continue;
			}
			r = [place.description rangeOfString:searchText options:NSCaseInsensitiveSearch];	// filter by address
			if (r.location != NSNotFound)
			{
				[displayItems addObject:place];
				continue;
			}
		}
	}
	[self.tableView reloadData];
}

@end
