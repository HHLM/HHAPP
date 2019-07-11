//
//  HHVideoViewController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHVideoViewController.h"

@interface HHVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HHVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    self.collectionView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.collectionView];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        CGFloat width = self.view.frame.size.width;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake(width/2 -15, 200);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width;
    if (indexPath.item%3 == 0) {
        CGFloat height = 40;
        height += indexPath.item / 3 * 20;
        return CGSizeMake(width-20, height);
    }
    return CGSizeMake(width/2-20, 150);
    return CGSizeMake(width/2-5, 200 + random()%200);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
@end
