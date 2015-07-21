#import "NSObject+Maybe.h"

@implementation NSObject (Maybe)

- (instancetype)maybe {
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else {
        return self;
    }
}

@end
