
//  Created by Tencent on 2023/06/09.
//  Copyright © 2023 Tencent. All rights reserved.

@import UIKit;

@interface TUICaptureImagePreviewController : UIViewController

@property(nonatomic) void (^commitBlock)(void);
@property(nonatomic) void (^cancelBlock)(void);

- (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end
