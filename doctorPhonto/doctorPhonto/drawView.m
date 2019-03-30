//
//  drawView.m
//  doctorPhonto
//
//  Created by xujiahui on 2019/3/29.
//  Copyright © 2019年 xujiahui. All rights reserved.
//

#import "drawView.h"
#import <QuartzCore/QuartzCore.h>

@interface drawView ()<UIPageViewControllerDelegate>
@property (nonatomic, assign) CGPoint currentPoint;
//@property(nonatomic,assign)CGPoint transPoint;
@property(nonatomic,assign)CGPoint endPoint;
@property(nonatomic,strong) UILabel * labeltext ;

#define centerSize 60

@end

@implementation drawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*初始化使用*/
-(instancetype)initWithFrame:(CGRect)frame{
 
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _labeltext.font = [UIFont systemFontOfSize:14];
        _labeltext.textColor = [UIColor redColor];
        _labeltext.backgroundColor = [UIColor clearColor];
        _labeltext.userInteractionEnabled = YES;
        [self addSubview:_labeltext];
        [self setup];
    }
    
    return self;
}

//加载完xib就走
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
//重新绘制
- (void)drawRect:(CGRect)rect {
    [self drawLine3];
}

- (void)drawLine3
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:_currentPoint];
    
    [path addLineToPoint:_endPoint];
    _labeltext.center = CGPointMake((_currentPoint.x - _endPoint.x)>0?_endPoint.x+centerSize:_endPoint.x-centerSize,(_currentPoint.y - _endPoint.y)>centerSize? _endPoint.y+centerSize:_endPoint.y-centerSize);
    _labeltext.text = [NSString stringWithFormat:@"%0.1f mm",sqrtf(pow((_currentPoint.x - _endPoint.x), 2) + pow((_currentPoint.y - _endPoint.y), 2))];
    
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor yellowColor] set];
    [path stroke];
}
//返回随机颜色
-(UIColor*)returnColor{

    return  [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:(arc4random_uniform(256))/255.0];
    
}
//定义手势
-(void)setup{
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}
-(void)panAction:(UIPanGestureRecognizer*)pan{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        self.currentPoint = [pan locationInView:self];
//    });
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
           
            self.currentPoint = [pan locationInView:self];
            
            break;
            
        case UIGestureRecognizerStateChanged:
          
            _endPoint = [pan locationInView:self];
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        case UIGestureRecognizerStateFailed:
            
            　break;
        default:
            break;
    }

    
    
    [self setNeedsDisplay];

}

@end


