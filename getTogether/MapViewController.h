//
//  MapViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/18/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <NSURLConnectionDelegate> {
    NSMutableArray *_users;
    NSMutableArray *_locations;
    NSMutableData *_responseData;
}

@end
