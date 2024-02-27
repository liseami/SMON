//
//  TUISearchBar_Minimalist.h
//  Pods
//
//  Created by harvy on 2020/12/23.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TUISearchBar_Minimalist;
@protocol TUISearchBarDelegate_Minimalist <NSObject>

@optional
- (void)searchBarDidEnterSearch:(TUISearchBar_Minimalist *)searchBar;
- (void)searchBarDidCancelClicked:(TUISearchBar_Minimalist *)searchBar;
- (void)searchBar:(TUISearchBar_Minimalist *)searchBar searchText:(NSString *)key;
@end

@interface TUISearchBar_Minimalist : UIView

@property(nonatomic, strong, readonly) UISearchBar *searchBar;

@property(nonatomic, weak) id<TUISearchBarDelegate_Minimalist> delegate;
// use weak, prevent circular references
@property(nonatomic, weak) UIViewController *parentVC;

- (void)setEntrance:(BOOL)isEntrance;

@end

NS_ASSUME_NONNULL_END
