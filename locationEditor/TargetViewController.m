//
//  TargetViewController.m
//  locationEditor
//
//  Created by laudmankimo on 2013/07/24.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import "TargetViewController.h"
#import "PlacemarkEditorViewController.h"

@interface TargetViewController ()

@end

@implementation TargetViewController
@synthesize my_mapView;
@synthesize updateTimer;

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

	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
        target  :self
        selector:@selector(timerMethod)
        userInfo:nil
        repeats :YES];
}

- (void)timerMethod
{
    if ((my_mapView.userLocation.coordinate.latitude != 0.0) &&
        (my_mapView.userLocation.coordinate.longitude != 0.0)
        )
    {
//        NSLog(@"lat = %f, lng = %f", my_mapView.userLocation.coordinate.latitude,
//		  							   my_mapView.userLocation.coordinate.longitude);
		CLLocationCoordinate2D center = my_mapView.userLocation.coordinate;
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 2000, 2000);
		MKCoordinateRegion adjustedRegion = [my_mapView regionThatFits:viewRegion];
		[my_mapView setRegion:adjustedRegion animated:YES];
//        [my_mapView setCenterCoordinate:my_mapView.userLocation.coordinate animated:YES];
        [updateTimer invalidate]; updateTimer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	my_mapView = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (IBAction)longPressAct:(UILongPressGestureRecognizer *)recognizer
{
    NSUInteger pin_count = [my_mapView.annotations count];

    if (recognizer.state != UIGestureRecognizerStateEnded)
        return;

    if (pin_count == 2)	// does not allow more than one PIN
        return;

    CGPoint                 touchPoint = [recognizer locationInView:my_mapView];
    CLLocationCoordinate2D  touchMapCoordinate =
	[my_mapView convertPoint:touchPoint toCoordinateFromView:my_mapView];

    DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:touchMapCoordinate addressDictionary:nil];

	// initial value
    annotation.title = @"点击按钮改变大头针名称";

    CLGeocoder  *myGecoder = [[CLGeocoder alloc] init];
    CLLocation  *mylocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];

    [myGecoder reverseGeocodeLocation:mylocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ((error == nil) && ([placemarks count] > 0))
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//			annotation.subtitle = [NSString stringWithFormat:@"%@", placemark.subThoroughfare];	// returns 277号
			annotation.subtitle = [NSString stringWithFormat:@"%@", placemark.name];
        }
        else if ((error == nil) && ([placemarks count] == 0))
        {
			annotation.subtitle = @"不是合理的地址";
        }
        else if (error != nil)
        {
			annotation.subtitle = [NSString stringWithFormat:@"错误代码 = %@", error];
        }
    }];

    [my_mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) // user dragging the pin and release the pin
    {
        DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
        annotation.subtitle = [NSString stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];

        CLGeocoder  *myGecoder = [[CLGeocoder alloc] init];
        CLLocation  *mylocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];

        [myGecoder reverseGeocodeLocation:mylocation completionHandler:^(NSArray *placemarks, NSError *error)
        {
            if ((error == nil) && ([placemarks count] > 0))
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                annotation.subtitle = [NSString stringWithFormat:@"%@", placemark.name];
            }
            else if ((error == nil) && ([placemarks count] == 0))
            {
                annotation.subtitle = @"不是合理的地址";
            }
            else if (error != nil)
            {
                annotation.subtitle = [NSString stringWithFormat:@"错误代码 = %@", error];
            }
        }];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[DDAnnotation class]])
	{
        static NSString *const  kPinAnnotationIdentifier = @"PinIdentifier";

		MKPinAnnotationView     *draggablePinView = (MKPinAnnotationView *)
		[my_mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];

        if (draggablePinView)
		{
            draggablePinView.annotation = annotation;
		}
        else
		{
            draggablePinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation
															  reuseIdentifier:kPinAnnotationIdentifier];
			draggablePinView.draggable = YES;
            draggablePinView.canShowCallout = YES;
            draggablePinView.animatesDrop = YES;
			draggablePinView.pinColor = MKPinAnnotationColorRed;

            UIButton *intoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[intoButton addTarget:self action:@selector(intoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
			draggablePinView.rightCalloutAccessoryView = intoButton;

		}
        return draggablePinView;
	}
    return nil;
}

- (void)intoButtonAction:(UIButton *)sender;
{
//根据 segue Identifier跳转界面
//    [self performSegueWithIdentifier:@"placemarkEditor" sender:self];
//以modal 方式跳转
//    [self presentModalViewController:nil animated:YES];
//压进一个viewcontroller
//    [self.navigationController pushViewController:nil animated:YES];
//弹出一个viewcontroller  相当与返回上一个界面
//    [self.navigationController popViewControllerAnimated:YES];
// 以 modal跳转的返回方法
//    [self dismissModalViewControllerAnimated:YES];
	PlacemarkEditorViewController *placemarkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"placemarkViewController"];

	placemarkVC.delegate = self;

	for (DDAnnotation *pdda in my_mapView.annotations)
	{
		if ([pdda isKindOfClass:[DDAnnotation class]])
		{
			placemarkVC.nameFromTarget = pdda.title;
			placemarkVC.descFromTarget = pdda.subtitle;
		}
	}

	[self presentViewController:placemarkVC animated:YES completion:nil];
}

-(void)passItemBack:(PlacemarkEditorViewController *)controller AnnotationName:(NSString *)name AnnotationDesc:(NSString *)desc
{
	for (DDAnnotation *pdda in my_mapView.annotations)
	{
		if ([pdda isKindOfClass:[DDAnnotation class]])
		{
			pdda.title = name;
			pdda.subtitle = desc;
			[self.delegate passItemBack:self PinCoordinate:pdda.location.coordinate AnnotationName:name AnnotationDesc:desc];
		}
	}

	[self.navigationController popViewControllerAnimated:YES];
//	[self dismissViewControllerAnimated:YES completion:nil];
//	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CLGeocoder  *geocoder = [[CLGeocoder alloc] init];
    __block NSString    *searchText = searchBar.text;

	//copy your annotations to an array
	NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithArray:my_mapView.annotations];
	//Remove the object userlocation
	[annotationsToRemove removeObject:my_mapView.userLocation];
	//Remove all annotations in the array from the mapView
	[my_mapView removeAnnotations:annotationsToRemove];
	annotationsToRemove = nil;

    [geocoder geocodeAddressString:searchText completionHandler:^(NSArray *placemarks, NSError *error)
    {
		DDAnnotation *annotation = nil;
		DDAnnotation *firstchoiceAnnotation = nil;
		
        if ((error == nil) && ([placemarks count] > 0))
        {
            for (CLPlacemark * aPlacemark in placemarks)
            {
                annotation = [[DDAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude, aPlacemark.location.coordinate.longitude) addressDictionary:nil];

                annotation.title = aPlacemark.name;
                annotation.subtitle = [NSString stringWithFormat:@"%@", aPlacemark.name];
                // annotation.subtitle = [NSString stringWithFormat:@"%@ (%f %f)", placemark.name, annotation.coordinate.latitude, annotation.coordinate.longitude];

                [my_mapView addAnnotation:annotation];

				if ([annotation.title isEqualToString:searchBar.text])
				{
					firstchoiceAnnotation = annotation;
				}
            }
        }
        else if ((error == nil) && ([placemarks count] == 0))
        {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"没有找到指定的地址或是地标"
			delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
        }
        else if (error != nil)
        {
			NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMessage
			delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
        }

        if (firstchoiceAnnotation != nil)
        {
            CLLocationCoordinate2D center = firstchoiceAnnotation.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 2000, 2000);
            MKCoordinateRegion adjustedRegion = [my_mapView regionThatFits:viewRegion];
            [my_mapView setRegion:adjustedRegion animated:YES];
        }
        else if (annotation != nil)
        {
            CLLocationCoordinate2D center = annotation.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 2000, 2000);
            MKCoordinateRegion adjustedRegion = [my_mapView regionThatFits:viewRegion];
            [my_mapView setRegion:adjustedRegion animated:YES];
        }
    }];

    [searchBar resignFirstResponder];
}

@end
