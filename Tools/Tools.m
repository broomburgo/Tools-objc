#import "Tools.h"

@implementation Tools

/// JSON validation

+ (NSArray* __nonnull)JSONValidatedArray:(NSArray* __nonnull)array {
    if (array.count == 0) {
        return @[];
    }
    if ([NSJSONSerialization isValidJSONObject:array]) {
        return array;
    }
    else {
        return [array map:^id(id object) {
            id validObject = object;
            if ([NSJSONSerialization isValidJSONObject:@[validObject]] == NO) {
                validObject = [validObject description];
            }
            return validObject;
        }];
    }
}

+ (NSDictionary* __nonnull)JSONValidatedDictionary:(NSDictionary* __nonnull)dictionary {
    if (dictionary.count == 0) {
        return @{};
    }
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        return dictionary;
    }
    else {
        return [dictionary map:^NSDictionary *(id key, id object) {
            id validKey = key;
            id validObject = object;
            if ([NSJSONSerialization isValidJSONObject:@[validKey]] == NO) {
                validKey = [validKey description];
            }
            if ([NSJSONSerialization isValidJSONObject:@[validObject]] == NO) {
                validObject = [validObject description];
            }
            return @{validKey: validObject};
        }];
    }
}

@end
