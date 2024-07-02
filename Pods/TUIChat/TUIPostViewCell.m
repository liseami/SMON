//
//  TUIPostViewCell.m
//  TUIChat
//
//  Created by mac xiao on 2024/6/24.
//

#import "TUIPostViewCell.h"

@implementation TUIPostViewCell

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
        [self.container addSubview:self.titleLable];
        self.titleLable.text = @"分享动态";
        self.titleLable.font = [UIFont boldSystemFontOfSize:15.0];
        
        self.myTitleLabel = [[UILabel alloc] init];
        [self.container addSubview:self.myTitleLabel];
        self.myTitleLabel.font = [UIFont systemFontOfSize:13.0];
        
        self.myImageView = [[UIImageView alloc]init];
        [self.container addSubview:self.myImageView];
        self.myImageView.layer.masksToBounds = YES;
        self.myImageView.layer.cornerRadius = 6.0;
    }
    return self;
}

- (void)fillWithData:(TUIPostCellData *)data;
{
    [super fillWithData:data];
    self.myTitleLabel.text = data.content;
    
    if (data.ImageUrl.length > 0) {
        NSURL *imageURL = [NSURL URLWithString:data.ImageUrl];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:
            ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error && data) {
                    // 图片数据下载成功，使用主队列更新UI
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新UI，例如设置图片到UIImageView
                        self.myImageView.image = image;
                    });
                }
            }];
         
        [dataTask resume];
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLable.mm_top(10).mm_left(68).mm_flexToRight(10).mm_flexToBottom(37);
    self.myTitleLabel.mm_top(25).mm_left(68).mm_flexToRight(10).mm_flexToBottom(15);
    self.myImageView.mm_top(0).mm_left(0).mm_width(56).mm_height(56);
//    self./*myLinkLabel*/.mm_sizeToFit().mm_left(10).mm_bottom(10);
}

+ (CGSize)getContentSize:(TUIMessageCellData *)data {
     CGSize size = CGSizeMake(194, 69);
     return size;
}




@end
