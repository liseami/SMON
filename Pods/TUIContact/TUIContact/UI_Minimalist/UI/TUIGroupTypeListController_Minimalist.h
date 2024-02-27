//
//  TUIGroupTypeListController.h
//  TUIContact
//
//  Created by wyl on 2022/8/23.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUIGroupTypeListController_Minimalist : UIViewController
@property(nonatomic, copy) NSString *cacheGroupType;
@property(nonatomic, copy) void (^selectCallBack)(NSString *groupType);

@end

NS_ASSUME_NONNULL_END
