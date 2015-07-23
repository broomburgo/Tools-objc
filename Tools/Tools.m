#import "Tools.h"

@implementation Tools

/// JSON validation

+ (NSArray*)JSONValidatedArray:(NSArray*)array {
    if (array.count == 0) {
        return array;
    }
    if ([NSJSONSerialization isValidJSONObject:array]) {
        return array;
    }
    else {
        return [array map:^id(id object) {
            if ([NSJSONSerialization isValidJSONObject:@[object]]) {
                return object;
            }
            else {
                return [object description];
            }
        }];
    }
}

+ (NSDictionary*)JSONValidatedDictionary:(NSDictionary*)dictionary {
    if (dictionary.count == 0) {
        return dictionary;
    }
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        return dictionary;
    }
    else {
        return [dictionary map:^NSDictionary *(id key, id object) {
            if ([NSJSONSerialization isValidJSONObject:@[object]]) {
                return @{key: object};
            }
            else {
                return @{key: [object description]};
            }
        }];
    }
}

@end
