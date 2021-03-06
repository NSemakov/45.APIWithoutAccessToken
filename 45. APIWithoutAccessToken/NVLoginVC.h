//
//  NVLoginVC.h
//  45. APIWithoutAccessToken
//
//  Created by Admin on 28.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NVUser;
typedef void(^CompletionBlock)(NVUser* friend);

@interface NVLoginVC : UIViewController
@property (strong,nonatomic) UIWebView* webView;

- (instancetype)initWithCompletionBlock:(CompletionBlock) completionBlock;
@end
