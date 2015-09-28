#import "Either.h"

@interface Either ()

@property (nonatomic, nullable) id right;
@property (nonatomic, nullable) id left;
@property (nonatomic, readonly) EitherType type;

@end
