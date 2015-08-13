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

- (id __nonnull)valueDefaultedTo:(id __nonnull)defaultValue {
    if (self.value != nil) {
        return self.value;
    }
    else {
        return defaultValue;
    }
}

+ (Optional* __nonnull)with:(id __nullable)value {
    Optional* optional = [Optional new];
    optional.value = value;
    return optional;
}

- (Optional* __nonnull)mapOptional:(id  __nonnull (^ __nonnull)(id __nonnull))mapBlock {
    switch (self.type) {
        case OptionalTypeNone: {
            return [Optional with:nil];
            break;
        }
        case OptionalTypeSome: {
            return [Optional with:mapBlock(self.value)];
            break;
        }
    }
}

- (Optional* __nonnull)flatMapOptional:(Optional * __nonnull (^ __nonnull)(id __nonnull))flatMapBlock {
    switch (self.type) {
        case OptionalTypeNone: {
            return [Optional with:nil];
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
