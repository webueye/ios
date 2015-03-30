//
//  ItemViewController.h
//  list
//
//  Created by rubys on 3/29/15.
//  Copyright (c) 2015 rubys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController

@property (strong, nonatomic) NSString *itemIndex;

@property (weak, nonatomic) IBOutlet UITextView *itemTextView;


@end
