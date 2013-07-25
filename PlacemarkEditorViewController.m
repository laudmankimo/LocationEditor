//
//  PlacemarkEditorViewController.m
//  locationEditor
//
//  Created by laudmankimo on 2013/07/24.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import "PlacemarkEditorViewController.h"

@interface PlacemarkEditorViewController ()

@end

@implementation PlacemarkEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.placemarkName.text = self.nameFromTarget;
	self.placemarkDesc.text = self.descFromTarget;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setPlacemarkName:nil];
	[self setPlacemarkDesc:nil];
	[super viewDidUnload];
}

- (IBAction)confirmButtonClicked:(id)sender
{
	// copy data
	[self.delegate passItemBack:self AnnotationName:self.placemarkName.text AnnotationDesc:self.placemarkDesc.text];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
	// does not copy data
	[self dismissModalViewControllerAnimated:YES];
}

@end
