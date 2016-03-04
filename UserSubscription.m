#import "BackendlessEntity.h"
#import "UserSubscription.h"

#import "Backendless.h"

#import "Tag.h"


@implementation UserSubscription

-(NSString *)createCode
{
  NSString *result = @"UserSubscription *userSubscription = [UserSubscription new];\n"
                      "userSubscription.userId = [backendless randomString:MIN(25,36)];\n"
                    "userSubscription.tags = [NSMutableArray arrayWithObjects:[Tag new], [Tag new], nil];\n"
                    "[backendless.persistenceService save:userSubscription response:^(tags *result) {\n"
                      "[backendless.persistenceService save:userSubscription response:^(UserSubscription *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)updateCode
{
  NSString *result = @"[backendless.persistenceService first:[UserSubscription class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "result.userId = [backendless randomString:MIN(25,36)];\n"
                      "[backendless.persistenceService save:userSubscription response:^(UserSubscription *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";

  return result;
}

-(NSString *)deleteCode
{
  NSString *result = @"[backendless.persistenceService first:[UserSubscription class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "[backendless.persistenceService remove:[UserSubscription class]\n"
                      "sid:result.objectId\n"
                      "response:^(NSNumber *success) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)basicFindCode
{
    NSString *result = @"QueryOptions *queryOptions = [QueryOptions query];\n"
                        "queryOptions.relationsDepth = @1;\n"
                        "BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];\n"
                        "dataQuery.queryOptions = queryOptions;\n"
                        "[backendless.persistenceService find:[UserSubscription class]\n"
                        "dataQuery:[BackendlessDataQuery query]\n"
                        "response:^(BackendlessCollection *collection){\n"
                        "}\n"
                        "error:^(Fault *fault) {\n"
                        "}];";
  return result;
}

-(NSString *)findFirstCode
{
  NSString *result = @"[backendless.persistenceService first:[UserSubscription class] response:^(UserSubscription *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findLastCode
{
  NSString *result = @"[backendless.persistenceService last:[UserSubscription class] response:^(UserSubscription *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findWithSortCode:(NSArray *)fields
{
  NSString *sort = [fields componentsJoinedByString:@"\", @\""];
  NSString *result =[NSString stringWithFormat:
                     @"BackendlessDataQuery *query = [BackendlessDataQuery query];\n"
                      "query.queryOptions = [QueryOptions query];\n"
                      "query.queryOptions.sortBy = @[@\"%@\"];\n"
                      "[backendless.persistenceService find:[UserSubscription class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}
-(NSString *)findWithReladed:(NSArray *)fields
{
  NSString *sort = [fields componentsJoinedByString:@"\", @\""];
  NSString *result =[NSString stringWithFormat:
                     @"BackendlessDataQuery *query = [BackendlessDataQuery query];\n"
                      "query.queryOptions = [QueryOptions query];\n"
                      "query.queryOptions.related = @[@\"%@\"];\n"
                      "[backendless.persistenceService find:[UserSubscription class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}

-(void)setValuesForProperties
{
  self.userId = [backendless randomString:MIN(25,36)];
  self.tags = [NSMutableArray arrayWithObjects:[Tag new], [Tag new], nil];
}
-(void)updateValuesForProperties
{
  self.userId = [backendless randomString:MIN(25,36)];
}
@end