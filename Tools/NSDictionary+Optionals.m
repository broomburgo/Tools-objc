#import "NSDictionary+Optionals.h"

@implementation NSDictionary (Optionals)

- (instancetype)key:(id<NSCopying>)key optional:(id)optional {
    if (optional == nil || key == nil) {
        return self;
    }
    NSDictionary* toAdd = @{key : optional};
    if ([self isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* m_self = (NSMutableDictionary*)self;
        [m_self addEntriesFromDictionary:toAdd];
        return self;
    }
    else {
        NSMutableDictionary* m_self = [self mutableCopy];
        [m_self addEntriesFromDictionary:toAdd];
        return [m_self copy];
    }
}

@end
