#import "Switch.h"
#import "Categories.h"

@interface Switch ()

@property (nonatomic) id value;
@property (nonatomic) BOOL isMatched;

@end

@implementation Switch

+ (Switch* __nonnull):(id __nonnull)value {
    return [Switch with:value isMatched:NO];
}

- (id)returnedValue {
    return self.isMatched ? self.value : nil;
}

+ (Switch*)with:(id)value isMatched:(BOOL)isMatched {
    return
    [[Switch new]
     setup:^(Switch* object){
         object.value = value;
         object.isMatched = isMatched;
         return object;
     }];
}

- (Switch* __nonnull)inCase:(BOOL(^ __nonnull)(id __nonnull))inCase :(id __nullable(^ __nonnull)(id __nonnull))returnBlock {
    if (self.isMatched) {
        return self;
    }
    if (inCase(self.value)) {
        return [Switch with:returnBlock(self.value) isMatched:YES];
    }
    return self;
}

- (Switch* __nonnull)otherwise:(id __nullable(^ __nonnull)(id __nonnull))returnBlock {
    if (self.isMatched) {
        return self;
    }
    return [Switch with:returnBlock(self.value) isMatched:YES];
}

@end
