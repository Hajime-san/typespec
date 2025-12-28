import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "(title)" })
@info(#{ version: "0.0.0" })
namespace title;

model Dog {
  @example("list") object: string;
  @example("msg_abc123") first_id: string;
  @example("msg_abc123") last_id: string;
  @example(false) has_more: boolean;
}

@route("/") @get op extensive(): Dog | {
  @statusCode
  @minValue(400)
  @maxValue(499)
  statusCode: int32;
} | {
  @statusCode
  @minValue(500)
  @maxValue(599)
  statusCode: int32;
};
