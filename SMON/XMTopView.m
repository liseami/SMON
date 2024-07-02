//
//  XMTopView.m
//  SMON
//
//  Created by mac xiao on 2024/6/20.
//

#import "XMTopView.h"


@interface XMTopView ()
{
    UIScrollView *scroll;
    UIPageControl *page;
}
@end
@implementation XMTopView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (id)init {
    return [self initWithFrame:CGRectZero];
}
-(void)setupUI{
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 180)];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width*3, 180);
    [self addSubview:scroll];
    
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 180, UIScreen.mainScreen.bounds.size.width/100, 20)];
    [self addSubview:page];
    page.currentPage = 0;
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    
}

bool haveData = NO;
-(void)setListArr:(NSArray *)ListArr{
    if (!haveData) {
        if (ListArr.count > 0) {
            haveData = YES;
            _ListArr = ListArr;
            int totalPage = (ListArr.count+1)%6 == 0 ? (ListArr.count+1)/6:(ListArr.count+1)/6+1;
            page.numberOfPages = totalPage;
            scroll.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width*totalPage, 180);
            float width = (UIScreen.mainScreen.bounds.size.width) / 2;
            
            for (int a = 0; a < ListArr.count; a++) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+(a/3)*width, (a)%3*60, width-1, 60-1)];
                [scroll addSubview:view];
                view.backgroundColor = [UIColor redColor];
                
                id uuu = [ListArr objectAtIndex:a];
                
                NSLog(@"%@",uuu);
                
            }
            
            
        }
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
