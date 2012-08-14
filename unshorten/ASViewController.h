//
//  ASViewController.h
//  unshorten
//
//  Created by Ahmad Salman on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *shortURLField;

- (IBAction)unshorten;

@end
