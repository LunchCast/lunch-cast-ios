#import "BackendlessEntity.h"
#import "Meal.h"

#import "Backendless.h"


@implementation Meal

-(NSString *)createCode
{
  NSString *result = @"Meal *meal = [Meal new];\n"
                      "meal.image = [backendless randomString:25];\n"
                      "meal.price = [backendless randomString:MIN(25,36)];\n"
                      "meal.description = [backendless randomString:MIN(25,36)];\n"
                      "meal.mealDescription = [backendless randomString:MIN(25,288)];\n"
                      "meal.name = [backendless randomString:MIN(25,36)];\n"
                      "[backendless.persistenceService save:meal response:^(Meal *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)updateCode
{
  NSString *result = @"[backendless.persistenceService first:[Meal class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "result.image = [backendless randomString:25];\n"
                      "result.price = [backendless randomString:MIN(25,36)];\n"
                      "result.description = [backendless randomString:MIN(25,36)];\n"
                      "result.mealDescription = [backendless randomString:MIN(25,288)];\n"
                      "result.name = [backendless randomString:MIN(25,36)];\n"
                      "[backendless.persistenceService save:meal response:^(Meal *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";

  return result;
}

-(NSString *)deleteCode
{
  NSString *result = @"[backendless.persistenceService first:[Meal class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "[backendless.persistenceService remove:[Meal class]\n"
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
                        "[backendless.persistenceService find:[Meal class]\n"
                        "dataQuery:[BackendlessDataQuery query]\n"
                        "response:^(BackendlessCollection *collection){\n"
                        "}\n"
                        "error:^(Fault *fault) {\n"
                        "}];";
  return result;
}

-(NSString *)findFirstCode
{
  NSString *result = @"[backendless.persistenceService first:[Meal class] response:^(Meal *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findLastCode
{
  NSString *result = @"[backendless.persistenceService last:[Meal class] response:^(Meal *first) {"
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
                      "[backendless.persistenceService find:[Meal class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
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
                      "[backendless.persistenceService find:[Meal class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}

-(void)setValuesForProperties
{
  self.image = [backendless randomString:25];
  self.price = [backendless randomString:MIN(25,36)];
  self.mealDescription = [backendless randomString:MIN(25,288)];
  self.name = [backendless randomString:MIN(25,36)];
}
-(void)updateValuesForProperties
{
  self.image = [backendless randomString:25];
  self.price = [backendless randomString:MIN(25,36)];
  self.mealDescription = [backendless randomString:MIN(25,288)];
  self.name = [backendless randomString:MIN(25,36)];
}
@end