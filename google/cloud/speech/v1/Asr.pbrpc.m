#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "Asr.pbrpc.h"
#import "Asr.pbobjc.h"
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>


@implementation StreamVoice

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  self = [super initWithHost:host
                 packageName:@"streaming_voice"
                 serviceName:@"StreamVoice"];
  return self;
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

#pragma mark - Class Methods

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

#pragma mark - Method Implementations

#pragma mark SendVoice(stream VoiceRequest) returns (stream TextReply)

- (void)sendVoiceWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, TextReply *_Nullable response, NSError *_Nullable error))eventHandler{
  [[self RPCToSendVoiceWithRequestsWriter:requestWriter eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToSendVoiceWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, TextReply *_Nullable response, NSError *_Nullable error))eventHandler{
  return [self RPCToMethod:@"SendVoice"
            requestsWriter:requestWriter
             responseClass:[TextReply class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
@end
#endif
