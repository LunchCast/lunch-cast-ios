#import "DataObjects.h"



@interface Meal : NSObject<DataObjects>

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *name;

@end
                    