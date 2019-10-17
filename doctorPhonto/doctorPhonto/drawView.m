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
@property(nonatomic,strong) UIImageView * imageviewPop ;

#define centerSize 60
#define BigGW 70
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
        
        _imageviewPop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BigGW, BigGW)];
        _imageviewPop.layer.cornerRadius = BigGW/2;
        _imageviewPop.layer.borderColor = [UIColor grayColor].CGColor;
        _imageviewPop.layer.borderWidth = 2;
        _imageviewPop.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changecallName" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changescall:) name:@"changecallName" object:nil];
        
    }
    
    return self;
}

//通知改变比例
-(void)changescall:(NSNotification*)notifacation{
 
   NSString * str =  notifacation.object;
    self.scals = [str floatValue];
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
    
    CGPoint center=CGPointMake(_labeltext.center.x, _labeltext.center.y-50);
    _imageviewPop.center =center;
    
    _labeltext.text = [NSString stringWithFormat:@"%0.1f mm",sqrtf(pow((_currentPoint.x - _endPoint.x), 2) + pow((_currentPoint.y - _endPoint.y), 2))*self.scals/3];
    
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor yellowColor] set];
    [path stroke];
    
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
//    CGContextScaleCTM(context, 1.5, 1.5);
//    CGContextTranslateCTM(context,-1*(_endPoint.x),-1*(_endPoint.y));
//    [self.imageviewPop.layer renderInContext:context];
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
//            [self addSubview:_imageviewPop];
            break;
            
        case UIGestureRecognizerStateChanged:
          
            _endPoint = [pan locationInView:self];
           
            break;
            
        case UIGestureRecognizerStateEnded:
            
            [_imageviewPop removeFromSuperview];
            
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


