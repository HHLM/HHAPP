//
//  HHNSObjectViewController.m
//  HHAPP
//
//  Created by Now on 2020/5/27.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "HHNSObjectViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "HHStuden.h"
@interface HHNSObjectViewController ()

@end

@implementation HHNSObjectViewController
/**
  @ interface NSObject <NSObject> {
      Class isa  OBJC_ISA_AVAILABILITY;
  }
 底层是结构体
 typedef struct objc_class *Class; 结构体指针

 LLVM ：clang -rewrite
 */

- (void)viewDidLoad {
    [super viewDidLoad];

    NSObject *obj = [[NSObject alloc] init];

    //obj 实际内容大小
    NSLog(@"实际内容大小：%ld", class_getInstanceSize([obj class]));
    
    NSLog(@"占用内存大小：%ld",malloc_size((__bridge const void*)obj));

    //obj占用内存大小
}

@end
