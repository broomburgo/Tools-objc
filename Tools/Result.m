#import "Result.h"

@interface Result ()

@property (nonatomic) id __nullable value;
@property (nonatomic) id __nullable error;

@end

@implementation Result

- (ResultType)type {
    if (self.error != nil) {
        return ResultTypeFailure;
    }
    return ResultTypeSuccess;
}

- (id __nonnull)valueDefaultedTo:(id __nonnull)defaultValue {
    if (self.type != ResultTypeFailure) {
        return self.value;
    }
    else {
        return defaultValue;
    }
}

+ (Result* __nonnull)failureWith:(NSError * __nonnull)error {
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

@end
