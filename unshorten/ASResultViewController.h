//
//  ASResultViewController.h
//  unshorten
//
//  Created by Ahmad Salman on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UITextView *fullURLField;
@property (strong, nonatomic) NSString *fullURL;

- (IBAction)resultViewButtons:(id)sender;

@end
