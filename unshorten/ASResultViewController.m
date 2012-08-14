//
//  ASResultViewController.m
//  unshorten
//
//  Created by Ahmad Salman on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASResultViewController.h"
#import "MBProgressHUD.h"


@interface ASResultViewController ()

- (void) copyURL;
- (void) openURL;
- (void) backToMainView;

@end

@implementation ASResultViewController

@synthesize resultView, fullURLField, fullURL;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // making it all pretty.. again
    resultView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Default.png"]];
   
    // putting the Long URL IN THE BOX!
    fullURLField.text = fullURL;
}

- (void)viewDidUnload {
    
    [self setFullURLField:nil];
    [self setResultView:nil];
    [self setFullURL:nil];
    [super viewDidUnload];
}

- (void) copyURL {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setURL:[NSURL URLWithString:fullURL]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
	hud.mode = MBProgressHUDModeCustomView;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
	hud.labelText = @"Copied";
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:1];
}

- (void) openURL {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
}

- (void) backToMainView {
    
    [self performSegueWithIdentifier:@"backToMainViewSegue" sender:self];
}

- (IBAction)resultViewButtons:(id)sender {
  
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
  
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self copyURL];
            break;
        case 1:
            [self openURL];
            break;
        case 2:
            [self backToMainView];
            break;
    }
}

@end
