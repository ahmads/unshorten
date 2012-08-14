//
//  ASUnshortener.m
//  unshorten
//
//  Created by Ahmad Salman on 7/29/12.
//
//

#import "ASUnshortener.h"


// the API url for untiny.me
// docs at: http://untiny.com/api/#service=1
#define API_URL @"http://untiny.me/api/1.0/extract/?format=json&url="

@implementation ASUnshortener

+ (void) unshortenURL:(NSString *)shortURL withCallback:(void (^)(NSString *error, NSString *longURL)) callback {
    
    // appened the short URL to the API URL
    // then create an NSURL object with the whole thing
    NSString *urlString = [API_URL stringByAppendingString:shortURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // preform the request asynchronously using GCD
    // if we don't do this the UI will lockup until the request is done, which is bad UX
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *longURL;
        NSString *errorMsg;

        // make the request
        NSData* response = [NSData dataWithContentsOfURL:url];
        
        if (response) {
            
            NSError *error;
            
            // iOS 5 JSON parsing awesomeness
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
            
            // look for the long URL and the error massage if any exsits
            longURL = [json objectForKey:@"org_url"];
            errorMsg = [[json objectForKey:@"error"] objectAtIndex:1];
        }
        
        // back to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
                        
            if (longURL) {
                callback(nil, longURL);
            }
            else if (errorMsg) {
                callback(errorMsg, nil);
            }
            else {
                callback(@"Something went wrong", nil);
            }
       });
    });
}

@end
