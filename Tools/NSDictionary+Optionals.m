#import "NSDictionary+Optionals.h"

@implementation NSDictionary (Optionals)

- (instancetype)key:(id<NSCopying>)key optional:(id)optional {
    if (optional == nil || key == nil) {
        return self;
    }
    if ([self isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* m_self = (NSMutableDictionary*)self;
        [m_self setObject:optional forKey:key];
        return self;
    }
    else {
        NSMutableDictionary* m_self = [self mutableCopy];
        [m_self setObject:optional forKey:key];
        return [NSDictionary dictionaryWithDictionary:m_self];
    }
}

- (instancetype)optionalDict:(NSDictionary*)optionalDict {
    if (optionalDict.count == 0) {
        return self;
    }
    if ([self isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* m_self = (NSMutableDictionary*)self;
        [m_self addEntriesFromDictionary:optionalDict];
        return self;
    }
    else {
        NSMutableDictionary* m_self = [self mutableCopy];
        [m_self addEntriesFromDictionary:optionalDict];
        return [NSDictionary dictionaryWithDictionary:m_self];
    }
}

@end
