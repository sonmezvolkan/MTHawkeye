//
// Copyright (c) 2008-present, Meitu, Inc.
// All rights reserved.
//
// This source code is licensed under the license found in the LICENSE file in
// the root directory of this source tree.
//
// Created on: 2017/7/3
// Created by: YWH
//

#import "MTHANRObserver.h"
#import <MTHawkeye/MTHawkeyeUtility.h>
#import "MTHANRDetectThread.h"
#import "MTHANRRecord.h"

@interface MTHANRObserver ()
@property (nonatomic, copy) MTHANRObserveResultHandler detectedHandler;
@property (nonatomic, strong) MTHANRDetectThread *detectThread;
@end

@implementation MTHANRObserver

- (void)dealloc {
    [self.detectThread cancel];
}

- (instancetype)initWithObserveResultHandler:(MTHANRObserveResultHandler)detectedHandler {
    (self = [super init]);
    if (self) {
        self.detectedHandler = detectedHandler;
    }
    return self;
}

- (BOOL)isRunning {
    if (!self.detectThread) {
        return false;
    }
    return !self.detectThread.isCancelled;
}

- (void)setShouldCaptureBackTrace:(BOOL)shouldCaptureBackTrace {
    _shouldCaptureBackTrace = shouldCaptureBackTrace;
    self.detectThread.shouldCaptureBackTrace = shouldCaptureBackTrace;
}

- (void)startWithDetectInterval:(float)detectIntervalInSeconds anrThreshold:(float)anrThresholdInSeconds {
    self.detectThread = [[MTHANRDetectThread alloc] init];
    self.detectThread.shouldCaptureBackTrace = self.shouldCaptureBackTrace;
    __weak typeof(self) weakSelf = self;
    [self.detectThread startWithDetectInterval:detectIntervalInSeconds
                       stallThresholdInSeconds:anrThresholdInSeconds
                                       handler:^(MTHANRRecord *_Nonnull anrRecord) {
                                           if (weakSelf) {
                                               weakSelf.detectedHandler(weakSelf, anrRecord);
                                           }
                                       }];
}

- (void)stop {
    [self.detectThread cancel];
    self.detectThread = nil;
}

@end
