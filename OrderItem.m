#import "BackendlessEntity.h"
#import "OrderItem.h"

#import "Backendless.h"

#import "Meal.h"

#import "Order.h"


@implementation OrderItem

-(NSString *)createCode
{
  NSString *result = @"OrderItem *orderItem = [OrderItem new];\n"
                      "orderItem.quantity = @((int)rand()%10000);\n"
                      "[backendless.persistenceService save:orderItem response:^(OrderItem *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)updateCode
{
  NSString *result = @"[backendless.persistenceService first:[OrderItem class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "result.quantity = @((int)rand()%10000);\n"
                      "[backendless.persistenceService save:orderItem response:^(OrderItem *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";

  return result;
}

-(NSString *)deleteCode
{
  NSString *result = @"[backendless.persistenceService first:[OrderItem class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "[backendless.persistenceService remove:[OrderItem class]\n"
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
                        "[backendless.persistenceService find:[OrderItem class]\n"
                        "dataQuery:[BackendlessDataQuery query]\n"
                        "response:^(BackendlessCollection *collection){\n"
                        "}\n"
                        "error:^(Fault *fault) {\n"
                        "}];";
  return result;
}

-(NSString *)findFirstCode
{
  NSString *result = @"[backendless.persistenceService first:[OrderItem class] response:^(OrderItem *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findLastCode
{
  NSString *result = @"[backendless.persistenceService last:[OrderItem class] response:^(OrderItem *first) {"
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
                      "[backendless.persistenceService find:[OrderItem class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
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
                      "[backendless.persistenceService find:[OrderItem class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}

-(void)setValuesForProperties
{
  self.quantity = @((int)rand()%10000);
  self.meal = [Meal new];
  self.order_id = [Order new];
}
-(void)updateValuesForProperties
{
  self.quantity = @((int)rand()%10000);
}
@end