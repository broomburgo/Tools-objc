#import "Result.h"
#import "Result_Internal.h"

@implementation Result

- (ResultType)type {
    return self.error != nil ? ResultTypeFailure : ResultTypeSuccess;
}

+ (Result* __nonnull)failureWith:(id __nonnull)error {
    Result* result = [Result new];
    result.error = error;
    result.value = nil;
    return result;
}


+ (Result* __nonnull)successWith:(id __nonnull)value {
    Result* result = [Result new];
    result.error = nil;
    result.value = value;
    return result;
}

- (Result* __nonnull)mapResult:(id  __nonnull (^ __nonnull)(id __nonnull))mapBlock {
    switch (self.type) {
        case ResultTypeFailure: {
            return [Result failureWith:self.error];
            break;
        }
        case ResultTypeSuccess: {
            return [Result successWith:mapBlock(self.value)];
            break;
        }
    }
}

- (Result* __nonnull)flatMapResult:(Result * __nonnull (^ __nonnull)(id __nonnull))flatMapBlock {
    switch (self.type) {
        case ResultTypeFailure: {
            return [Result failureWith:self.error];
            break;
        }
        case ResultTypeSuccess: {
            return flatMapBlock(self.value);
            break;
        }
    }
}

- (id __nonnull)selectForSuccess:(id __nonnull(^ __nonnull)(id __nonnull))successBlock selectForFailure:(id __nonnull(^ __nonnull)(id __nonnull))failureBlock {
    switch (self.type) {
        case ResultTypeSuccess: {
            return successBlock(self.value);
            break;
        }
        case ResultTypeFailure: {
            return failureBlock(self.error);
            break;
        }
    }
}

- (id __nonnull)valueDefaultedTo:(id)defaultValue {
    return [self
            selectForSuccess:^id (id value) {
                return value;
            }
            selectForFailure:^id (id _) {
                return defaultValue;
            }];
}

@end
