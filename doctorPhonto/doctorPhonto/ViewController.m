//
//  ViewController.m
//  doctorPhonto
//
//  Created by xujiahui on 2019/3/29.
//  Copyright © 2019年 xujiahui. All rights reserved.
//

#import "ViewController.h"
#import "myButton.h"
#import "UIViewExt.h"
#import "drawView.h"

#define IPHONEHIGHT(b) [UIScreen mainScreen].bounds.size.height*((b)/1294.0)
#define IPHONEWIDTH(a) [UIScreen mainScreen].bounds.size.width*((a)/750.0)
#define Addheight self.navigationController.navigationBar.frame.size.height+IPHONEHIGHT(20)

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) UIImageView * imageX ;
@property(nonatomic,strong) UIScrollView * scrollview ;
//缩放复原
@property(nonatomic,strong) UIButton * btnRecovery ;
//测量
@property(nonatomic,strong) UIButton * btnMeasuring ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"X光片";
    self.view.backgroundColor = [UIColor whiteColor];
    ///set UI
    [self setUI];
    
//    [self imageX];
}


-(void)setUI{
    
    UIButton * butpoho = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [butpoho setTitle:@"选择照片" forState:UIControlStateNormal];
    [butpoho setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    butpoho.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    
    [butpoho addTarget:self action:@selector(selctphotos) forControlEvents:UIControlEventTouchUpInside];
    butpoho.center = self.view.center;
    [self.view addSubview:butpoho];
    
    
    

}

//工具按钮
-(void)setUITools{
    
    self.view.backgroundColor = [UIColor blackColor];
    //
    _btnRecovery = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(IPHONEWIDTH(20), Addheight+IPHONEHIGHT(30), IPHONEWIDTH(140), IPHONEHIGHT(80)) title:@"复原" colors:[UIColor whiteColor] andBackground:[UIColor blackColor] tag:11 andBlock:^(myButton *button) {
        
        [self.scrollview setZoomScale:1 animated:YES];
    }];
    _btnRecovery.layer.borderWidth = 2;
    _btnRecovery.layer.borderColor =[UIColor grayColor].CGColor;
    _btnRecovery.layer.cornerRadius = 4;
    [self.view addSubview:_btnRecovery];
    
    //画线 量长度
    _btnMeasuring = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_btnRecovery.right+IPHONEWIDTH(20), _btnRecovery.top, _btnRecovery.width, _btnRecovery.height) title:@"测量" colors:[UIColor whiteColor] andBackground:[UIColor blackColor] tag:12 andBlock:^(myButton *button) {
        drawView * draw = [[drawView alloc] initWithFrame:self.imageX.bounds];
        
        [self.scrollview addSubview:draw];
     
    }];
    
    _btnMeasuring.layer.borderWidth = 2;
    _btnMeasuring.layer.borderColor =[UIColor grayColor].CGColor;
    _btnMeasuring.layer.cornerRadius = 4;
    [self.view addSubview:_btnMeasuring];
 
    //调整窗宽
   UIButton *  btnJunp = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(_btnMeasuring.right+IPHONEWIDTH(20), _btnMeasuring.top, _btnRecovery.width, _btnRecovery.height) title:@"调窗" colors:[UIColor whiteColor] andBackground:[UIColor blackColor] tag:12 andBlock:^(myButton *button) {
     
       
       
    }];
    
    btnJunp.layer.borderWidth = 2;
    btnJunp.layer.borderColor =[UIColor grayColor].CGColor;
    btnJunp.layer.cornerRadius = 4;
    [self.view addSubview:btnJunp];
    
}
//选择照片
-(void)selctphotos{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:nil completion:^{
        
    }];
    
    
}
//选择照片会掉
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];

    //处理照片大小
    self.scrollview.contentSize = CGSizeMake(image.size.width, image.size.height);
    
    self.imageX.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    self.imageX.image = image;
    
    
    //工具
    [self setUITools];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageX;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale

{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [_scrollview setZoomScale:scale animated:NO];
}

// 这个方法是针对scrollView在缩小时无法居中的问题，scrollView放大，只要在设置完zoomScale之后设置偏移量为(0,0)即可实现放大居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.imageX.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    
}

//选择照片代理

//懒加载
-(UIScrollView*)scrollview{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-140)];
        _scrollview.backgroundColor = [UIColor blackColor];
        _scrollview.bounces = NO;
        //设置缩放
        _scrollview.maximumZoomScale = 2.0;
        _scrollview.minimumZoomScale = 0.1;
        [_scrollview setZoomScale:1 animated:YES];
        //允许缩放更小。之后自动弹回
        _scrollview.bouncesZoom = YES;
        
        _scrollview.delegate =self;
        
        [self.view addSubview:_scrollview];
        
    }
    
    return  _scrollview;
}
-(UIImageView*)imageX
{
    
    if (!_imageX) {
        _imageX = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageX.backgroundColor = [UIColor blackColor];
        _imageX.userInteractionEnabled = YES;
        [_scrollview addSubview:_imageX];
    }

    return _imageX;
}
@end



