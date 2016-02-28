#import "DataObjects.h"



@interface Tag : NSObject<DataObjects>

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSDate *created;

@end
                    