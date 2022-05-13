//
// Copyright (c) 2008-present, Meitu, Inc.
// All rights reserved.
//
// This source code is licensed under the license found in the LICENSE file in
// the root directory of this source tree.
//
// Created on: 02/12/2017
// Created by: EuanC
//


#import <UIKit/UIKit.h>

@interface MTHMonitorView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)attachToEdgeAndSavePosition;

@end
