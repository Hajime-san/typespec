import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "(title)" })
@info(#{ version: "0.0.0" })
namespace title;

model Pet {
  name: string;
}

@route("/") @get op extensive(): /** The request has succeeded. */ Pet | /** Client error */ {
  @statusCode
  @minValue(400)
  @maxValue(499)
  statusCode: int32;
} | /** Server error */ {
  @statusCode
  @minValue(500)
  @maxValue(599)
  statusCode: int32;
};
