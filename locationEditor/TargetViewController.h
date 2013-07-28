//
//  TargetViewController.h
//  locationEditor
//
//  Created by laudmankimo on 2013/07/24.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlacemarkEditorViewController.h"
#import "DDAnnotation.h"

@class TargetViewController;

@protocol TargetDelegate <NSObject>

-(void) passItemBack:(TargetViewController *)controller PinCoordinate:(CLLocationCoordinate2D)coordinate AnnotationName:(NSString *)name AnnotationDesc:(NSString *)desc;

@end

@interface TargetViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate, PlacemarkEditorDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *my_mapView;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (weak, nonatomic) id<TargetDelegate>delegate;

- (IBAction)longPressAct:(id)sender;

@end
