#import "Match.h"
#import "Categories.h"

@interface Match ()

@property (nonatomic) id value;
@property (nonatomic) BOOL isMatched;

@end

@implementation Match

+ (Match* __nonnull):(id __nonnull)value {
    return [Match with:value isMatched:NO];
}

- (id)matchedValue {
    return self.isMatched ? self.value : nil;
}

+ (Match*)with:(id)value isMatched:(BOOL)isMatched {
    return
    [[Match new]
     setup:^(Match* object){
         object.value = value;
         object.isMatched = isMatched;
         return object;
     }];
}

- (Match* __nonnull)inCase:(BOOL(^ __nonnull)(id __nonnull))inCase :(id __nullable(^ __nonnull)(id __nonnull))returnBlock {
    if (self.isMatched) {
        return self;
    }
    if (inCase(self.value)) {
        return [Match with:returnBlock(self.value) isMatched:YES];
    }
    return self;
}

- (Match* __nonnull)otherwise:(id __nullable(^ __nonnull)(id __nonnull))returnBlock {
    if (self.isMatched) {
        return self;
    }
    return [Match with:returnBlock(self.value) isMatched:YES];
}

@end
