//
//  ImageSaveOp.h
//  photo-ios
//
//  Created by James on 2019/5/30.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface flutter_info : NSObject
@property(retain,nonatomic) NSString* name;
@property(retain,nonatomic) NSString* prise;
@property(retain,nonatomic) NSString* prise_now;
@property(retain,nonatomic) NSString* sells;
@property(retain,nonatomic) NSString* Coupon;
@property(retain,nonatomic) NSString* url6;
@property(retain,nonatomic) NSString* url7;

-(id)initWithDic:(NSDictionary*)dic;
@end

@interface ImageSaveOp : NSObject

-(void)_generateImgurl:(NSURL*)imgUrl obInfo:(flutter_info*)ob;

@end

NS_ASSUME_NONNULL_END
