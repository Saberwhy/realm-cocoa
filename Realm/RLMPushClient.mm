////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "RLMPushClient_Private.hpp"
#import "RLMSyncUser_Private.hpp"
#import "RLMApp_Private.hpp"
#import "sync/push_client.hpp"

@implementation RLMPushClient {
    std::unique_ptr<realm::app::PushClient> _pushClient;
}

- (instancetype)initWithPushClient:(realm::app::PushClient&&)pushClient {
    if (self = [super init]) {
        _pushClient = std::make_unique<realm::app::PushClient>(std::move(pushClient));
        return self;
    }
    return nil;
}

- (void)registerDeviceWithToken:(NSString *)token user:(RLMSyncUser *)user completion:(RLMOptionalErrorBlock)completion {
    self->_pushClient->register_device(token.UTF8String, user._syncUser, ^(util::Optional<app::AppError> error) {
        if (error && error->error_code) {
            return completion(RLMAppErrorToNSError(*error));
        }
        completion(nil);
    });
}


- (void)deregisterDeviceForUser:(RLMSyncUser *)user completion:(RLMOptionalErrorBlock)completion {
    self->_pushClient->deregister_device(user._syncUser, ^(util::Optional<app::AppError> error) {
        if (error && error->error_code) {
            return completion(RLMAppErrorToNSError(*error));
        }
        completion(nil);
    });
}

@end
