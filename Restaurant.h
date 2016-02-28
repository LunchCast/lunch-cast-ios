#import "DataObjects.h"



@interface Restaurant : NSObject<DataObjects>

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *telefon;

@property (nonatomic, strong) NSNumber *eta;

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *meals;
@end
                    