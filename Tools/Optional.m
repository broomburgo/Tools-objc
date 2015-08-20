#import "Optional.h"
#import "Result.h"

@interface Optional ()

@property (nonatomic) id __nullable value;

@end

@implementation Optional

- (OptionalType)type {
    if (self.value == nil) {
        return OptionalTypeNone;
    }
    return OptionalTypeSome;
}

- (id __nonnull)valueDefaultedTo:(id __nonnull(^ __nonnull)(void))lazyDefaultValue {
    if (self.value != nil) {
        return self.value;
    }
    else {
        return lazyDefaultValue();
    }
}

+ (Optional* __nonnull)with:(id __nullable)value {
    Optional* optional = [Optional new];
    optional.value = value;
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
            return [Optional with:self.value when:filterBlock];
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
            return [Optional with:mapBlock(self.value)];
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
            return flatMapBlock(self.value);
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
            return [Result successWith:self.value];
            break;
    }
}

- (void)applyIfPossible:(void(^ __nonnull)(id __nonnull))applyBlock {
    switch (self.type) {
        case OptionalTypeNone:
            break;
            
        case OptionalTypeSome:
            applyBlock(self.value);
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
