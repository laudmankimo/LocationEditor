//
//  Place.h
//  Miller
//
//  Created by kadir pekel on 2/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *description;
@property (nonatomic, strong) NSNumber  *latitude;
@property (nonatomic, strong) NSNumber  *longitude;
@end
