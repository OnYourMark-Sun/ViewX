//
//  myButton.m
//  02-button的封装-block
//
//  Created by AirspaceProject on 16/6/16.
//  Copyright © 2016年 AirspaceProject All rights reserved.
//

#import "myButton.h"
//字体大小
#define IPHONEHIGHT(b) [UIScreen mainScreen].bounds.size.height*((b)/1294.0)
#define IPHONEWIDTH(a) [UIScreen mainScreen].bounds.size.width*((a)/750.0)

#define UiFontIPH(num) [UIFont systemFontOfSize:IPHONEWIDTH(num)]
@interface myButton()
@property (nonatomic,assign) id<myButtonDelegate>delegate;

@property (nonatomic,copy) myButtonBlock block;
@end

@implementation myButton
+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title tag:(NSInteger)tag andDelegate:(id)delegate{
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = tag;
    button.titleLabel.font = UiFontIPH(34);
    button.delegate = delegate;
    
    return button;

}

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title colors:color andBackground:(UIColor *)backgroundColor tag:(NSInteger)tag andBlock:(myButtonBlock)block{
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = UiFontIPH(24);
    
    button.tag = tag;
    
    button.block = block;
    
    return button;
    
}


-(void)buttonClicked:(UIButton *)btn{

//    //调用协议方法
//    if ([_delegate respondsToSelector:@selector(myButtonClicked:)]) {
//        [_delegate performSelector:@selector(myButtonClicked:) withObject:self];
//    }
    
    self.block(self);
}

+(myButton *)buttonWithType:(UIButtonType)type frame:(CGRect)frame  tag:(NSInteger)tag image:(NSString *)image andBlock:(myButtonBlock)block{
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([image hasPrefix:@"http:"] || [image hasPrefix:@"https:"]) {
        
        //[button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:image]];
    }else{
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }

    button.titleLabel.font = UiFontIPH(34);
    button.tag = tag;
    
    button.block = block;
    
    return button;

}

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title titleColor:(UIColor*)color andBackground:(UIColor *)backgroundColor cornerRadius:(CGFloat)corner tag:(NSInteger)tag andBlock:(myButtonBlock)block{
    
    
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.layer.cornerRadius = corner;
    button.layer.masksToBounds = YES;
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = UiFontIPH(34);
    button.tag = tag;
    
    button.block = block;
    
    return button;
    
    
}

@end
