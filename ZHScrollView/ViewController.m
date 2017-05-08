//
//  ViewController.m
//  ZHScrollView
//
//  Created by 1860 on 2017/5/8.
//  Copyright © 2017年 HangZhao. All rights reserved.
//

#import "ViewController.h"

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView *tmpScrollView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSArray *imageArr;
@property (nonatomic , strong) UIImageView *currentImage;
@property (nonatomic , strong) UIImageView *backImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentImage = [[UIImageView alloc] init];
    self.backImage = [[UIImageView alloc] init];
    //如果使用网络加载图片的，加载方式要使用SDWebimage加载图片
    self.imageArr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    [self setUpScrollView];
}

- (void)setUpScrollView{
    [self.currentImage setImage:[UIImage imageNamed:self.imageArr[0]]];
    [self.backImage setImage:[UIImage imageNamed:self.imageArr[1]]];
    [self.currentImage setTag:0];
    [self.backImage setTag:1];
    [self.currentImage setFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 200)];
    [self.backImage setFrame:CGRectMake(KScreenWidth*2, 0, KScreenWidth, 200)];
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    [self.tmpScrollView setPagingEnabled:YES];
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth*4, 0)];
    [self.tmpScrollView setDelegate:self];
    static dispatch_once_t onceToken;
    __weak typeof(self) weakSelf = self;
    dispatch_once(&onceToken, ^{
        [weakSelf.tmpScrollView setContentOffset:CGPointMake(KScreenWidth, 0)];
    });
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setFrame:CGRectMake(0, 180, KScreenWidth, 20)];
    [self.pageControl setNumberOfPages:4];
    [self.pageControl setCurrentPage:0];
    //未选中的颜色
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [self.tmpScrollView addSubview:self.currentImage];
    [self.tmpScrollView addSubview:self.backImage];
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:self.pageControl];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > KScreenWidth) {
        [self.backImage setFrame:CGRectMake(KScreenWidth * 2, 0, KScreenWidth, 200)];
        self.backImage.tag = (self.currentImage.tag + 1)%self.imageArr.count;
        [self.backImage setImage:[UIImage imageNamed:self.imageArr[self.backImage.tag]]];
    }else if (offsetX < KScreenWidth){
        [self.backImage setFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        self.backImage.tag = (self.currentImage.tag - 1 + self.imageArr.count)%self.imageArr.count;
        [self.backImage setImage:[UIImage imageNamed:self.imageArr[self.backImage.tag]]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    [scrollView setContentOffset:CGPointMake(KScreenWidth, 0)];
    if (offsetX>0.5*KScreenWidth && offsetX<1.5*KScreenWidth) {
        return;
    }
    self.currentImage.image = self.backImage.image;
    self.currentImage.tag = self.backImage.tag;
    [self.pageControl setCurrentPage:self.backImage.tag];
}


@end
