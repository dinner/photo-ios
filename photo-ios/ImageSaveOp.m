//
//  ImageSaveOp.m
//  photo-ios
//
//  Created by James on 2019/5/30.
//  Copyright © 2019 James. All rights reserved.
//

#import "ImageSaveOp.h"
#import <UIKit/UIKit.h>
#import "NSString+Size.h"

#define SAVE_PATH  \
[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/image"]

#define INFO_VIEW_HEIGHT    200.f
#define PI 3.14159265358979323846

@implementation flutter_info

-(id)init{
    self=[super init];
    self.name=@"李宁超屌夏季畅销板鞋学生鞋";
    self.prise_now=@"$99";
    self.prise=@"100";
    self.sells=@"10万";
    self.Coupon=@"10";
    return self;
}

-(id)initWithDic:(NSDictionary*)dic;{
    self=[super init];
    self.name=[dic objectForKey:@""];
    self.prise_now=[dic objectForKey:@""];
    self.prise=[dic objectForKey:@""];
    self.sells=[dic objectForKey:@""];
    self.Coupon=[dic objectForKey:@"10"];
    self.url6=[dic objectForKey:@""];
    self.url7=[dic objectForKey:@""];
    return self;
}

@end

@implementation ImageSaveOp

-(void)getImg:(NSArray*)ar{
    for (int i=0; i<ar.count; i++) {
        NSDictionary* dic=ar[i];
        flutter_info* fi=[[flutter_info alloc] initWithDic:dic];
        
    }
}

-(void)_generateImgurl:(NSURL*)imgUrl obInfo:(flutter_info*)ob{
    NSLog(@"%@",imgUrl);
    __weak ImageSaveOp* weakSelf=self;
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    NSURLRequest* imgRequest=[NSURLRequest requestWithURL:imgUrl];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData * data = [NSData dataWithContentsOfURL:location];
        UIImage* commodityImg=[UIImage imageWithData:data];
                
        UIImage* resultImg = [weakSelf generateImg:commodityImg info:ob];
        [weakSelf saveFile:resultImg name:@"1.png"];
    }];
    [task resume];
}

//相对infoview偏移
#define tmImgY_deviation_x                  10
#define tmImgY_deviation_y                  newImgSize.height+INFO_VIEW_HEIGHT*0.1

#define goodsName_deviation_x               45
#define goodsName_deviation_y               newImgSize.height+INFO_VIEW_HEIGHT*0.1

#define goodsPrise_deviation_x              10
#define goodsPrise_deviation_y              newImgSize.height+INFO_VIEW_HEIGHT*0.75

#define goodsNowPrise_deviation_x           10
#define goodsNowPrise_deviation_y           newImgSize.height+INFO_VIEW_HEIGHT*0.85

#define goodsSells_deviation_x              200
#define goodsSells_deviation_y              newImgSize.height+INFO_VIEW_HEIGHT*0.85

#define qrcode_deviation_x                  260
#define qrcode_deviation_y                  newImgSize.height+INFO_VIEW_HEIGHT*0.2

#define qrcode_width                        newImgSize.height+INFO_VIEW_HEIGHT*0.3

#define NAME_WIDTH                          sceenSize.width-120
#define NAME_HEIGHT                         INFO_VIEW_HEIGHT*0.7

#define COUPON_FONT                         [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0]
#define PRISE_FONT                          [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14.0]

#define radians(degrees)  (degrees)*M_PI/180.0f

-(UIImage*)generateImg:(UIImage*)img info:(flutter_info*)ob{
    CGSize sceenSize=[[UIScreen mainScreen] bounds].size;
    CGSize newImgSize=[self generateTargetSize:CGSizeMake(sceenSize.width, sceenSize.height-INFO_VIEW_HEIGHT) imgSize:img.size];
    CGSize resultImgSize=CGSizeMake(newImgSize.width, newImgSize.height+INFO_VIEW_HEIGHT);
    
    UIGraphicsBeginImageContext(resultImgSize);
    [img drawInRect:CGRectMake(0, 0, resultImgSize.width, newImgSize.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //优惠券
    NSString* Coupon=ob.Coupon;
    if (![Coupon isEqualToString:@""]) {
        NSString* couponText=[NSString stringWithFormat:@" 优惠券：￥%@ ",Coupon];
        CGSize size= [NSString sizeWithString:couponText andFont:COUPON_FONT andMaxSize:CGSizeMake(200, 50)];
        const CGFloat couponTextDevision=30.f;
        [couponText drawInRect:CGRectMake(sceenSize.width-size.width, resultImgSize.height-INFO_VIEW_HEIGHT-couponTextDevision-size.height, size.width, size.height) withAttributes:@{ NSForegroundColorAttributeName:[UIColor yellowColor],
                         NSBackgroundColorAttributeName:[UIColor redColor],
                        NSFontAttributeName:COUPON_FONT}];
        
//        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//        [[UIColor yellowColor] setFill];
//        CGContextAddArcToPoint(context,100,80,130,150,50);
        
        /*
        CGFloat r=size.height/2;//半径
        CGContextMoveToPoint(context, sceenSize.width-size.width, resultImgSize.height-INFO_VIEW_HEIGHT-couponTextDevision+size.height/2);//移动画笔到指定坐标点
        UIColor* aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];//红色
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextAddArc(context, sceenSize.width-size.width, resultImgSize.height-INFO_VIEW_HEIGHT-couponTextDevision+size.height/2, r, 0, 1.0*PI, 1); //添加一个圆
        CGContextDrawPath(context, kCGPathFill); //填充路径
         */
        [[UIColor redColor] setFill];//填充颜色
        CGContextSetRGBStrokeColor(context,1,0,0,1.0);//画笔颜色
        CGFloat r=size.height/2;//半径
        //逆时针画扇形
        CGContextMoveToPoint(context, sceenSize.width-size.width, resultImgSize.height-INFO_VIEW_HEIGHT-couponTextDevision-size.height/2);
        CGContextAddArc(context, sceenSize.width-size.width, resultImgSize.height-INFO_VIEW_HEIGHT-couponTextDevision-size.height/2, r, radians(90), radians(90+180), 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathEOFillStroke);
    }
    
    CGSize priseSize= [NSString sizeWithString:[NSString stringWithFormat:@"原价 %@",ob.prise] andFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14.0] andMaxSize:CGSizeMake(100, 40)];
    CGSize nameSize=[NSString sizeWithString:ob.name andFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0] andMaxSize:CGSizeMake(NAME_WIDTH, NAME_HEIGHT)];
    
    //绘制白色信息展示背景
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, newImgSize.height, newImgSize.width, INFO_VIEW_HEIGHT));
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, goodsPrise_deviation_x, goodsPrise_deviation_y+priseSize.height/2);
    CGContextAddLineToPoint(context, goodsPrise_deviation_x+priseSize.width, goodsPrise_deviation_y+priseSize.height/2);
    CGContextStrokePath(context);
    
    [[UIImage imageNamed:@"tmall.png"] drawInRect:CGRectMake(tmImgY_deviation_x, tmImgY_deviation_y, 30, 30)];
    [ob.name drawInRect:CGRectMake(goodsName_deviation_x, goodsName_deviation_y, nameSize.width, nameSize.height) withAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
             NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0],
         NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"原价 %@",ob.prise] drawInRect:CGRectMake(goodsPrise_deviation_x, goodsPrise_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                        NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:14.0],
                NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"现价 %@",ob.prise_now] drawInRect:CGRectMake(goodsNowPrise_deviation_x, goodsNowPrise_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                        NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:15.0],
                        NSKernAttributeName:@1.0 }];
    [[NSString stringWithFormat:@"销量 %@",ob.sells] drawInRect:CGRectMake(goodsSells_deviation_x, goodsSells_deviation_y, 100, 30) withAttributes:@{ NSForegroundColorAttributeName:[UIColor grayColor],
                          NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:15.0],
                          NSKernAttributeName:@1.0 }];
    
    UIImage* resultImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImg;
}

-(CGSize)generateTargetSize:(CGSize)targetSize imgSize:(CGSize)imgSize{
    CGFloat targetWidth=targetSize.width;
    CGFloat targetHeight=targetSize.height;
    CGFloat width=imgSize.width;
    CGFloat height=imgSize.height;
    CGFloat scaleFactor = 0.0;
    
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    return CGSizeMake(width * scaleFactor, height * scaleFactor);
}

-(void)saveFile:(UIImage*)img name:(NSString*)fileName{
    NSData *imgData=UIImagePNGRepresentation(img);
    [self createFileDirectories];
    NSString* filePath=[SAVE_PATH stringByAppendingPathComponent:fileName];
    if([imgData writeToFile:filePath atomically:YES])
    {
        NSLog(@"保存成功");
        NSLog(@"%@",filePath);
    }
    else{
        NSLog(@"保存失败");
    }
}

- (void)createFileDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:SAVE_PATH
                                        isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:SAVE_PATH
         withIntermediateDirectories:YES
                          attributes:nil
                               error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
        NSLog(@"%@",SAVE_PATH);
    }
    isDir = FALSE;
    isDirExist = [fileManager fileExistsAtPath:SAVE_PATH
                                   isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:SAVE_PATH
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
}



@end
