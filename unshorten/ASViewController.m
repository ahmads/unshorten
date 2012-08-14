//
//  ASViewController.m
//  unshorten
//
//  Created by Ahmad Salman on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASViewController.h"
#import "ASResultViewController.h"
#import "ASUnshortener.h"
#import "MBProgressHUD.h"


@interface ASViewController ()

-(void) checkPasteboard;

@end

@implementation ASViewController

@synthesize mainView, shortURLField;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // making it all pretty
    mainView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Default.png"]];
    
    // setting focus to the text filed to pop the keypad
    [shortURLField becomeFirstResponder];
    
    // registering an ovbserver to know when the app has finished launching
    // and check for a URL in the pasteboard using "checkPasteboard"
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkPasteboard)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

// for convenience, this will check if there is a URL in the pasteboard (clipboard)
// if so, it will put it in the URL field
- (void) checkPasteboard {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
    if (pasteboard.URL)
        shortURLField.text = [pasteboard.URL absoluteString];
    else if (pasteboard.string && [[pasteboard.string lowercaseString] hasPrefix:@"http://"])
        shortURLField.text = pasteboard.string;
}

- (void)viewDidUnload {
    
    [self setShortURLField:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}

- (IBAction)unshorten {
    
    NSString *shortURL = shortURLField.text;
    
    if (shortURL.length == 0) {
        // show an error massage if we don't have a short URL
        UIAlertView *emptyFieldAlert = [[UIAlertView alloc] initWithTitle:@"unshorten"
                                                        message:@"There has to be a short URL first, for it to be unshortened"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [emptyFieldAlert show];
        
        // return to "exit" the function
        return;
    }
    
    // create and show custom activiy inscator using MBProgressHUD
    // see: https://github.com/jdg/MBProgressHUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Unshortinging";
    hud.yOffset = -90;

    
    [ASUnshortener unshortenURL:shortURL withCallback:^(NSString *error, NSString *longURL) {
        
        // hide the activity endicator
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (longURL) {
            
            // so we have a long URL, perform the segue and send the long URL along with it
            [self performSegueWithIdentifier:@"viewFullURLSegue" sender:longURL];
        }
        else {
            
            // show an error massage if we don't have a long URL
            UIAlertView *noResultAlert = [[UIAlertView alloc] initWithTitle:@"Oops.."
                                                                    message:error
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
            [noResultAlert show];
        }
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString *)result {
    
    if ([segue.identifier isEqualToString: @"viewFullURLSegue"]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // pass the long URL to the view contorller of the view that will be loaded
        // which will be ASResultViewController in this case
        [segue.destinationViewController setFullURL: result];        
    }
}

// handle the 'Done' button on the soft keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self unshorten];
    return YES;
}


@end
