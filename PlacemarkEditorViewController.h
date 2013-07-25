//
//  PlacemarkEditorViewController.h
//  locationEditor
//
//  Created by laudmankimo on 2013/07/24.
//  Copyright (c) 2013年 laudmankimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlacemarkEditorViewController;

@protocol PlacemarkEditorDelegate <NSObject>

-(void) passItemBack:(PlacemarkEditorViewController *)controller AnnotationName:(NSString *)name AnnotationDesc:(NSString *)desc;

@end

@interface PlacemarkEditorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *placemarkName;
@property (weak, nonatomic) IBOutlet UITextField *placemarkDesc;
@property (strong, nonatomic) NSString *nameFromTarget;
@property (strong, nonatomic) NSString *descFromTarget;
@property (weak, nonatomic) id<PlacemarkEditorDelegate>delegate;

- (IBAction)confirmButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
