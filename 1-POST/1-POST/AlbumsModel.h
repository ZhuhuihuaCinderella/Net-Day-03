//
//  AlbumsModel.h
//  1-POST
//
//  Created by Qianfeng on 16/1/20.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumModel.h"
#import "JSONModel.h"
@interface AlbumsModel :JSONModel
@property (nonatomic, strong) NSNumber *totalcount;
@property (nonatomic, strong) NSNumber *totalpics;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSArray<AlbumModel *>  *albums;
@end
