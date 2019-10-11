//
//  HHLikeTableView.h
//  HHAPP
//
//  Created by Now on 2019/10/11.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHLikeTableView;

@protocol HHLikeTableViewDelegate <NSObject>

@required

- (UITableViewCell *)likeTableView:(HHLikeTableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (CGFloat)likeTableViewCellRowHeight:(HHLikeTableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

@interface HHLikeTableView : UITableView

@property (nonatomic, weak) id <HHLikeTableViewDelegate> likeDelegate;
@property (nonatomic, strong) RACSubject *subject;
@property (nonatomic, strong) NSArray *titlesArray;

@end

NS_ASSUME_NONNULL_END
