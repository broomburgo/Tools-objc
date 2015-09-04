#import "Match.h"

@interface Match ()

@property (nonatomic) id value;
@property (nonatomic) BOOL isMatched;

@end

@implementation Match

+ (Match* __nonnull):(id __nonnull)value {
    return [Match value:value isMatched:NO];
}

+ (Match*)value:(id)value isMatched:(BOOL)isMatched {
    Match* match = [Match new];
    match.value = value;
    match.isMatched = isMatched;
    return match;
}

- (Match* __nonnull)with:(BOOL(^ __nonnull)(id __nonnull))withBlock give:(id __nullable(^ __nonnull)(id __nonnull))giveBlock {
    if (self.isMatched) {
        return self;
    }
    if (withBlock(self.value)) {
        return [Match value:giveBlock(self.value) isMatched:YES];
    }
    return self;
}

- (id __nonnull)otherwise:(id __nullable(^ __nonnull)())otherwiseBlock {
    if (self.isMatched) {
        return self.value;
    }
    self.isMatched = YES;
    return otherwiseBlock();
}

@end
