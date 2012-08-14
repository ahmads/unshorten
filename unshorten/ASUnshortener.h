//
//  ASUnshortener.h
//  unshorten
//
//  Created by Ahmad Salman on 7/29/12.
//
//

#import <Foundation/Foundation.h>

@interface ASUnshortener : NSObject

+ (void) unshortenURL:(NSString *)shortURL
         withCallback:(void (^)(NSString *error, NSString *longURL)) callback;

@end
