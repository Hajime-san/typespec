import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "@typespec/streams";
import "@typespec/sse";
import "@typespec/events";

using Http;
using OpenAPI;
using SSE;

@service(#{ title: "SSE Import Scenarios" })
@info(#{ version: "0.0.0" })
namespace SSEImportScenarios;

model UserConnect {
  username: string;
}

model UserMessage {
  text: string;
}

@events
union ChannelEventsNoTerminal {
  userconnect: UserConnect,
  usermessage: UserMessage,
}

@events
union ChannelEventsWithTerminal {
  userconnect: UserConnect,
  usermessage: UserMessage,

  @TypeSpec.Events.contentType("text/plain")
  @TypeSpec.SSE.terminalEvent
  @extension("x-ms-sse-terminal-event", true)
  "[done]",
}

@events
union ChannelEventWithCustomContentType {
  @TypeSpec.Events.contentType("application/octet-stream")
  binary: Base64,
}

@route("/channel/no-terminal") @get op subscribeToChannelNoTerminal(
): /** A request body to add a stream of typed data. */ SSEStream<ChannelEventsNoTerminal>;

@route("/channel/no-terminal-post") @post op subscribeToChannelNoTerminal(
  /** Request body for subscribing to a channel without terminal event. */
  @body body: {
    channelId?: string;
  },
): /** A request body to add a stream of typed data. */ SSEStream<ChannelEventsNoTerminal>;

@route("/channel/with-terminal") @get op subscribeToChannelWithTerminal(
): /** A request body to add a stream of typed data. */ SSEStream<ChannelEventsWithTerminal>;

@route("/data/custom-content-type") @get op subscribeToDataStream(
): /** A data stream with custom content types. */ SSEStream<ChannelEventWithCustomContentType>;
