#import "Result.h"
#import "Result_Internal.h"

@implementation Result

- (ResultType)type {
    return self.error != nil ? ResultTypeFailure : ResultTypeSuccess;
}

+ (Result* __nonnull)failureWith:(id __nonnull)error {
    Result* result = [Result new];
    result.error = error;
    result.get = nil;
    return result;
}


+ (Result* __nonnull)successWith:(id __nonnull)value {
    Result* result = [Result new];
    result.error = nil;
    result.get = value;
    return result;
}

- (Result* __nonnull)map:(id  __nonnull (^ __nonnull)(id __nonnull))mapBlock {
    switch (self.type) {
        case ResultTypeFailure: {
            return [Result failureWith:self.error];
            break;
        }
        case ResultTypeSuccess: {
            return [Result successWith:mapBlock(self.get)];
            break;
        }
    }
}

- (Result* __nonnull)flatMap:(Result * __nonnull (^ __nonnull)(id __nonnull))flatMapBlock {
    switch (self.type) {
        case ResultTypeFailure: {
            return [Result failureWith:self.error];
            break;
        }
        case ResultTypeSuccess: {
            return flatMapBlock(self.get);
            break;
        }
    }
}

- (id __nonnull)ifSuccess:(id __nonnull(^ __nonnull)(id __nonnull))successBlock ifFailure:(id __nonnull(^ __nonnull)(id __nonnull))failureBlock {
    switch (self.type) {
        case ResultTypeSuccess: {
            return successBlock(self.get);
            break;
        }
        case ResultTypeFailure: {
            return failureBlock(self.error);
            break;
        }
    }
}

- (id __nonnull)getOrElse:(id __nonnull(^ __nonnull)(void))lazyDefaultValue {
    return [self
            ifSuccess:^id (id value) {
                return value;
            }
            ifFailure:^id (id _) {
                return lazyDefaultValue();
            }];
}

@end
