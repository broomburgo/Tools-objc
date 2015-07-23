#import "NSArray+Optionals.h"

@implementation NSArray (Optionals)

- (instancetype)optional:(id)optional {
    if (optional == nil) {
        return self;
    }
    if ([self isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray* m_self = (NSMutableArray*)self;
        [m_self addObject:optional];
        return self;
    }
    else {
        return [self arrayByAddingObject:optional];
    }
}

@end
