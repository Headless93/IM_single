//
//  DFGridImageView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFGridImageView.h"
#import "UIImageView+WebCache.h"
#import "DFImageUnitView.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define Padding 2

#define OneImageMaxWidth [UIScreen mainScreen].bounds.size.width*0.5

@interface DFGridImageView()


@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSMutableArray *srcImages;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIButton *oneImageButton;


@end

@implementation DFGridImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageViews = [NSMutableArray array];
        
        [self initView];
    }
    return self;
}

-(void) initView
{
    CGFloat x, y, width, height;
    
    width = (self.frame.size.width - 2*Padding)/3;
    height = width;
    
    for (int row=0; row<3; row++) {
        for (int column=0; column<3; column++) {
            
            x = (width+Padding)*column;
            y = (height+Padding)*row;
            DFImageUnitView *imageUnitView = [[DFImageUnitView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [self addSubview:imageUnitView];
            imageUnitView.hidden = YES;
            [imageUnitView.imageButton addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [_imageViews addObject:imageUnitView];
        }
    }
    
    _oneImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _oneImageView.hidden = YES;
    _oneImageView.backgroundColor = [UIColor lightGrayColor];
    
    
    _oneImageButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _oneImageButton.hidden = YES;
    //_oneImageButton.backgroundColor = [UIColor lightGrayColor];
    [_oneImageButton addTarget:self action: @selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_oneImageView];
    [self addSubview:_oneImageButton];
    
    
}
-(void)updateWithImages:(NSMutableArray *)images srcImages:(NSMutableArray *)srcImages oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight
{
    
    self.images = images;
    self.srcImages = srcImages;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (self.images.count == 1) {
        id img = [self.images objectAtIndex:0];
        if ([img isKindOfClass:[UIImage class]]) {
            UIImage *image = img;
            oneImageWidth = image.size.width;
            oneImageHeight = image.size.height;
        }else if([img isKindOfClass:[NSString class]]){
            UIImage *image;
            
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
            BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
            if (isExist) {
                image = [UIImage imageWithContentsOfFile:filePath];
            } else {
                __weak typeof(self) weakSelf = self;
                [[DFFileManager sharedInstance] saveFileToLocal:filePath url:img];
                [DFFileManager sharedInstance].saveBlock = ^{
                    if (weakSelf.saveBlock) {
                        weakSelf.saveBlock();
                    }
                };
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
                image = nil;
            }
            /*
            BOOL isExist =  [manager diskImageExistsForURL:[NSURL URLWithString:img]];
            if (isExist) {
                image = [[manager imageCache] imageFromDiskCacheForKey:img];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
                image = [UIImage imageWithData:data];
            }
             */
            oneImageWidth = image.size.width;
            oneImageHeight = image.size.height;
        }
    }
    
    if (self.images.count == 1) {
        _oneImageView.hidden = NO;
        _oneImageButton.hidden = NO;
        if (oneImageWidth > OneImageMaxWidth) {
            _oneImageView.frame = CGRectMake(0, 0, OneImageMaxWidth, oneImageHeight*(OneImageMaxWidth/oneImageWidth));
            _oneImageButton.frame = CGRectMake(0, 0, OneImageMaxWidth, oneImageHeight*(OneImageMaxWidth/oneImageWidth));;
        }else{
            _oneImageView.frame = CGRectMake(0, 0, oneImageWidth, oneImageHeight);
            _oneImageButton.frame = CGRectMake(0, 0, oneImageWidth, oneImageHeight);
        }
        
        id img = [self.images objectAtIndex:0];
        if ([img isKindOfClass:[UIImage class]]) {
            _oneImageView.image = img;
        }else{
            
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
            BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
            
//            BOOL isExist =  [manager diskImageExistsForURL:[NSURL URLWithString:img]];
            if (isExist) {
                _oneImageView.image = [UIImage imageWithContentsOfFile:filePath];
            }else{
                [_oneImageView sd_setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:0]]];
            }
        }
        _oneImageButton.tag = 0;
        
    }else{
        _oneImageView.hidden = YES;
    }
    
    for (int i=0; i< _imageViews.count; i++) {
        DFImageUnitView *imageUnitView = [_imageViews objectAtIndex:i];
        [imageUnitView.imageButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.images.count == 1) {
            imageUnitView.hidden = YES;
        }else{
            
            if (self.images.count == 4) {
                if (i == 0 || i == 1 ) {
                    id img = [self.images objectAtIndex:i];
                    if ([img isKindOfClass:[UIImage class]]) {
                        imageUnitView.imageView.image = img;
                    }else{
                        NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
                        BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
//                        BOOL isExist =  [manager diskImageExistsForURL:[NSURL URLWithString:img]];
                        if (isExist) {
                            imageUnitView.imageView.image = [UIImage imageWithContentsOfFile:filePath];
                        }else{
                            [imageUnitView.imageView sd_setImageWithURL:[NSURL URLWithString:img]];
                        }
                    }
                    imageUnitView.hidden = NO;
                    imageUnitView.imageButton.tag = i;
                }else if (i == 3 || i == 4 ) {
                    
                    id img = [self.images objectAtIndex:i-1];
                    if ([img isKindOfClass:[UIImage class]]) {
                        imageUnitView.imageView.image = img;
                    }else{
                        NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
                        BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
//                        BOOL isExist =  [manager diskImageExistsForURL:[NSURL URLWithString:img]];
                        if (isExist) {
                            imageUnitView.imageView.image = [UIImage imageWithContentsOfFile:filePath];
                        }else{
                            [imageUnitView.imageView sd_setImageWithURL:[NSURL URLWithString:img]];
                        }
                    }
                    
                    imageUnitView.hidden = NO;
                    imageUnitView.imageButton.tag = i-1;
                }else{
                    imageUnitView.hidden = YES;
                }
            }else{
                if (i < self.images.count) {
                    
                    id img = [self.images objectAtIndex:i];
                    if ([img isKindOfClass:[UIImage class]]) {
                        imageUnitView.imageView.image = img;
                    }else{
                        NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
                        BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
//                        BOOL isExist =  [manager diskImageExistsForURL:[NSURL URLWithString:img]];
                        if (isExist) {
                            imageUnitView.imageView.image = [UIImage imageWithContentsOfFile:filePath];
                        }else{
                            [imageUnitView.imageView sd_setImageWithURL:[NSURL URLWithString:img]];
                        }
                    }
                    
                    imageUnitView.imageButton.tag = i;
                    imageUnitView.hidden = NO;
                }else{
                    imageUnitView.hidden = YES;
                }
            }
        }
        
    }
}


-(void) onClickImage:(UIView *) sender
{
    
    NSLog(@"tag: %ld", (long)sender.tag);
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    if (self.srcImages.count > 1) {
        
        for (int i=0; i<self.images.count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            
            id img = [self.srcImages objectAtIndex:i];
            if ([img isKindOfClass:[UIImage class]]) {
                photo.image = img;
            }else{
                photo.url = [NSURL URLWithString:[self.srcImages objectAtIndex:i]];
            }
            photo.srcImageView = ((DFImageUnitView *)[_imageViews objectAtIndex:i]).imageView;
            [photos addObject:photo];
        }
        
    }else{
        MJPhoto *photo = [[MJPhoto alloc] init];
        id img = [self.srcImages objectAtIndex:0];
        if ([img isKindOfClass:[UIImage class]]) {
            photo.image = img;
        }else{
            photo.url = [NSURL URLWithString:[self.srcImages objectAtIndex:0]];
        }
        
        photo.srcImageView = _oneImageView;
        [photos addObject:photo];
        
    }
    
    
    browser.photos = photos;
    browser.currentPhotoIndex = sender.tag;
    
    [browser show];
    
    
}


+(CGFloat)getHeight:(NSMutableArray *)images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight
{
    CGFloat height= (maxWidth - 2*Padding)/3;
    
    if (images == nil || images.count == 0) {
        return 0.0;
    }
    
    if (images.count == 1) {
        id img = [images objectAtIndex:0];
        if ([img isKindOfClass:[UIImage class]]) {
            UIImage *image = img;
            oneImageWidth = image.size.width;
            oneImageHeight = image.size.height;
        }else if([img isKindOfClass:[NSString class]]){
            UIImage *image;
            
            NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",DF_CACHEPATH, [DFToolUtil md5:img]];
            BOOL isExist = [[DFFileManager sharedInstance] checkLocalFile:filePath];
            if (isExist) {
                image = [UIImage imageWithContentsOfFile:filePath];
            } else {
                [[DFFileManager sharedInstance] saveFileToLocal:filePath url:img];
                [DFFileManager sharedInstance].saveBlock = ^{
                    
                };
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
                image = nil;
            }
            oneImageWidth = image.size.width;
            oneImageHeight = image.size.height;
        }
        
        if (oneImageWidth > OneImageMaxWidth) {
            return oneImageHeight*(OneImageMaxWidth/oneImageWidth);
        }
        return oneImageHeight;
    }
    
    if (images.count >1 && images.count <=3 ) {
        return height;
    }
    
    if (images.count >3 && images.count <=6 ) {
        return height*2+Padding;
    }
    
    return height*3+Padding*2;
    
}


- (void)touchUpInside:(id)sender
{
    NSLog(@"%@", sender);
}


-(NSInteger) getIndexFromPoint: (CGPoint) point
{
    
    UIView *view = self.superview.superview.superview;
    //NSLog(@"view: %@", view);
    NSLog(@"touch: x: %f  y: %f", point.x, point.y);
    
    CGFloat x = view.frame.origin.x + self.frame.origin.x+60;
    CGFloat y = view.frame.origin.y + self.frame.origin.y;
    
    NSLog(@"abs-grid: x: %f  y:%f", x, y);
    
    NSInteger diffY = point.y - y;
    NSInteger diffX = point.x - x;
    if (diffY <0 || diffX <0) {
        return -1;
    }
    
    if (_images.count == 1) {
        if (diffX > _oneImageButton.frame.size.width || diffY > _oneImageButton.frame.size.height) {
            return -1;
        }
        return 0;
    }
    
    
    NSLog(@"diffY: %ld  diffX: %ld", diffY, diffX);
    
    CGFloat gridWidth = self.frame.size.width;
    NSInteger size = gridWidth/3+20;
    //NSLog(@"size: %ld", size);
    
    if (diffY> gridWidth || diffX > gridWidth) {
        return -1;
    }
    
    
    NSInteger index = diffX/size + 3*(diffY/size);
    NSLog(@"index: %ld", index);
    
    if (_images.count == 4) {
        if (index == 2) {
            return -1;
        }
        if (index >=3) {
            index--;
        }
    }
    
    if (index<0 || index>_images.count-1) {
        return -1;
    }
    
    return index;
}


@end
