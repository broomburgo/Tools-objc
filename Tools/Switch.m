#import "Switch.h"
#import "Categories.h"

@interface Switch ()

@property (nonatomic) id __nonnull value;
@property (nonatomic) BOOL isMatched;

@end

@implementation Switch

+ (Switch*)value:(id __nonnull)value {
    return [Switch with:value isMatched:NO];
}

- (id __nullable)returnedValue {
    return self.isMatched ? self.value : nil;
}

+ (Switch*)with:(id __nonnull)value isMatched:(BOOL)isMatched {
    return
    [[Switch new]
     setup:^(Switch* object){
         object.value = value;
         object.isMatched = isMatched;
     }];
}

- (Switch* __nonnull)inCase:(BOOL)inCase :(id  __nullable (^ __nonnull)(void))returnBlock {
    if (self.isMatched) {
        return self;
    }
    if (inCase) {
        return [Switch with:returnBlock() isMatched:YES];
    }
    return self;
}

- (Switch* __nonnull)otherwise:(id __nullable(^ __nonnull)(void))returnBlock {
    if (self.isMatched) {
        return self;
    }
    return [Switch with:returnBlock() isMatched:YES];
}

@end
