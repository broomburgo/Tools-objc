#import "Optional.h"
#import "Result.h"

@interface Optional ()

@property (nonatomic) id __nullable get;

@end

@implementation Optional

- (OptionalType)type {
    if (self.get == nil) {
        return OptionalTypeNone;
    }
    return OptionalTypeSome;
}

- (id __nonnull)getOrElse:(id __nonnull(^ __nonnull)(void))lazyElse {
    if (self.get != nil) {
        return self.get;
    }
    else {
        return lazyElse();
    }
}

+ (Optional* __nonnull)with:(id __nullable)value {
    Optional* optional = [Optional new];
    optional.get = value;
    return optional;
}

+ (Optional* __nonnull)with:(id __nullable)value as:(Class __nonnull)requiredClass {
    return [[Optional with:value]
            flatMap:^Optional * __nonnull(id __nonnull actualValue) {
                if ([actualValue isKindOfClass:[requiredClass class]]) {
                    return [Optional with:actualValue];
                }
                else {
                    return [Optional with:nil];
                }
            }];
}

+ (Optional* __nonnull)with:(id __nullable)value when:(BOOL(^ __nonnull)(id __nonnull value))ifBlock {
    return [[Optional with:value]
            flatMap:^Optional * __nonnull(id __nonnull actualValue) {
                if (ifBlock(actualValue)) {
                    return [Optional with:actualValue];
                }
                else {
                    return [Optional with:nil];
                }
            }];
}

- (Optional* __nonnull)filter:(BOOL(^ __nonnull)(id __nonnull))filterBlock {
    switch (self.type) {
        case OptionalTypeNone: {
            return self;
            break;
        }
        case OptionalTypeSome: {
            return [Optional with:self.get when:filterBlock];
            break;
        }
    }
}

- (Optional* __nonnull)map:(id  __nonnull (^ __nonnull)(id __nonnull))mapBlock {
    switch (self.type) {
        case OptionalTypeNone: {
            return self;
            break;
        }
        case OptionalTypeSome: {
            return [Optional with:mapBlock(self.get)];
            break;
        }
    }
}

- (Optional* __nonnull)flatMap:(Optional * __nonnull (^ __nonnull)(id __nonnull))flatMapBlock {
    switch (self.type) {
        case OptionalTypeNone: {
            return self;
            break;
        }
        case OptionalTypeSome: {
            return flatMapBlock(self.get);
            break;
        }
    }
}

- (Result* __nonnull)resultWithError:(id __nonnull)error {
    switch (self.type) {
        case OptionalTypeNone:
            return [Result failureWith:error];
            break;
            
        case OptionalTypeSome:
            return [Result successWith:self.get];
            break;
    }
}

- (void)applyIfPossible:(void(^ __nonnull)(id __nonnull))applyBlock {
    switch (self.type) {
        case OptionalTypeNone:
            break;
            
        case OptionalTypeSome:
            applyBlock(self.get);
            break;
    }
}

@end

@implementation NSDictionary (Optional)

- (Optional* __nonnull)optionalForKey:(id __nonnull)key as:(Class __nonnull)requiredClass {
    if (key == nil) {
        return [Optional with:nil];
    }
    id value = [self objectForKey:key];
    if (value == nil) {
        return [Optional with:nil];
    }
    if ([value isKindOfClass:requiredClass] == NO) {
        return [Optional with:nil];
    }
    return [Optional with:value];
}

@end
