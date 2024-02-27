//
//  TUISearchExtensionObserver_Minimalist.m
//  TUISearch
//
//  Created by harvy on 2023/4/3.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUISearchExtensionObserver_Minimalist.h"

#import <TUICore/TUICore.h>
#import <TUICore/TUIDefine.h>

#import "TUISearchBar_Minimalist.h"

@interface TUISearchExtensionObserver_Minimalist () <TUIExtensionProtocol>

@end

@implementation TUISearchExtensionObserver_Minimalist

+ (void)load {
    [TUICore registerExtension:TUICore_TUIConversationExtension_ConversationListBanner_MinimalistExtensionID
                        object:TUISearchExtensionObserver_Minimalist.shareInstance];
}

static id gShareInstance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      gShareInstance = [[self alloc] init];
    });
    return gShareInstance;
}

#pragma mark - TUIExtensionProtocol
- (BOOL)onRaiseExtension:(NSString *)extensionID parentView:(UIView *)parentView param:(nullable NSDictionary *)param {
    if (![extensionID isKindOfClass:NSString.class]) {
        return NO;
    }

    if ([extensionID isEqualToString:TUICore_TUIConversationExtension_ConversationListBanner_MinimalistExtensionID]) {
        if (![param isKindOfClass:NSDictionary.class] || parentView == nil || ![parentView isKindOfClass:UIView.class]) {
            return NO;
        }
        UIViewController *modalVC = [param tui_objectForKey:TUICore_TUIConversationExtension_ConversationListBanner_ModalVC asClass:UIViewController.class];
        NSString *sizeStr = [param tui_objectForKey:TUICore_TUIConversationExtension_ConversationListBanner_BannerSize asClass:NSString.class];
        CGSize size = CGSizeFromString(sizeStr);

        TUISearchBar_Minimalist *searchBar = [[TUISearchBar_Minimalist alloc] init];
        searchBar.frame = CGRectMake(0, 0, size.width, size.height);
        [searchBar setParentVC:modalVC];
        [searchBar setEntrance:YES];
        [parentView addSubview:searchBar];
        return YES;
    } else {
        // do nothing
        return NO;
    }
}

@end
