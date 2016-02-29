//
//  CellButton.h
//  getTogether
//
//  Created by Brendan Walsh  on 10/6/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//
//  This is an ABSTRACT CLASS. Do not use without subclassing.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton

@property (strong, nonatomic) NSNumber *associatedID;
@property (strong, nonatomic) NSIndexPath *indPath;

@end
