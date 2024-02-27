//
//  TUIChatPopContextRecentView.h
//  TUIChat
//
//  Created by wyl on 2022/10/24.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TUIChatPopContextRecentView;
@protocol TUIChatPopContextRecentEmojiDelegate <NSObject>

- (void)popRecentViewClickArrow:(TUIChatPopContextRecentView *)faceView;
- (void)popRecentViewClickface:(TUIChatPopContextRecentView *)faceView tag:(NSInteger)tag;

@end

@interface TUIChatPopContextRecentView : UIView

@property(nonatomic, strong, readonly) NSMutableArray *faceGroups;
@property(nonatomic, assign) BOOL needShowbottomLine;
@property(nonatomic, strong) UIButton *arrowButton;

- (void)setData:(NSMutableArray *)data;

@property(nonatomic, weak) id<TUIChatPopContextRecentEmojiDelegate> delegate;

@end

@interface TUIChatPopContextExtionItem : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) UIColor *titleColor;

@property(nonatomic, strong) UIFont *titleFont;

@property(nonatomic, assign) CGFloat weight;

@property(nonatomic, strong) UIImage *markIcon;

@property(nonatomic, assign) CGFloat itemHeight;

@property(nonatomic, assign) BOOL needBottomLine;

@property(nonatomic, copy) void (^actionHandler)(TUIChatPopContextExtionItem *item);

- (instancetype)initWithTitle:(NSString *)title markIcon:(UIImage *)markIcon weight:(NSInteger)weight withActionHandler:(void (^)(id action))actionHandler;

@end

@interface TUIChatPopContextExtionView : UIView

- (void)configUIWithItems:(NSMutableArray<TUIChatPopContextExtionItem *> *)items topBottomMargin:(CGFloat)topBottomMargin;

@end

NS_ASSUME_NONNULL_END
