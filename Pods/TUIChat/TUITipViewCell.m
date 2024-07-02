//
//  TUITipViewCell.m
//  TUIChat
//
//  Created by mac xiao on 2024/6/28.
//

#import "TUITipViewCell.h"

@implementation TUITipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [[UILabel alloc]init];
        [self addSubview:self.titleLable];
        self.titleLable.font = [UIFont boldSystemFontOfSize:15.0];
        self.titleLable.textColor = [UIColor whiteColor];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
//        self.titleLable.text = @"今日TA与你最匹配";
        self.titleLable.font = [UIFont systemFontOfSize:12.0];
        self.titleLable.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        self.avatarView.hidden = YES;
        
    }
    return self;
}

- (void)fillWithData:(XMTipsMessageCellData *)data{
    [super fillWithData:data];
    self.titleLable.text = data.messageContent;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.container.frame = CGRectMake(0, 0, Screen_Width, 30);
    self.titleLable.frame = CGRectMake(0, 0, Screen_Width, 30);
    self.avatarView.hidden = YES;
}

+ (CGSize)getContentSize:(TUIMessageCellData *)data {
     CGSize size = CGSizeMake(Screen_Width, 30);
     return size;
}

@end
