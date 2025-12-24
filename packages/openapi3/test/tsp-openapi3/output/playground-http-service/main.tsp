import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Widget Service" })
@info(#{ version: "0.0.0" })
@tagMetadata("Widgets")
namespace WidgetService;

model Error {
  code: int32;
  message: string;
}

model Widget {
  id: string;
  weight: int32;
  color: "red" | "blue";
}

model WidgetCreate {
  weight: int32;
  color: "red" | "blue";
}

model WidgetUpdate {
  weight?: int32;
  color?: "red" | "blue";
}

@tag("Widgets")
@route("/widgets")
@get
op Widgets_list(
): /** The request has succeeded. */ Body<Widget[]> | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

@tag("Widgets")
@route("/widgets")
@post
op Widgets_create(
  @body body: WidgetCreate,
): /** The request has succeeded. */ Widget | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

@tag("Widgets")
@route("/widgets/{id}")
@delete
op Widgets_delete(
  @path id: string,
): /** There is no content to send for this request, but the headers may be useful.  */ NoContentResponse | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

@tag("Widgets")
@route("/widgets/{id}")
@get
op Widgets_read(
  @path id: string,
): /** The request has succeeded. */ Widget | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

@tag("Widgets")
@route("/widgets/{id}")
@patch
op Widgets_update(
  ...Parameters.Widget.id,
  @body body: WidgetUpdate,
): /** The request has succeeded. */ Widget | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

@tag("Widgets")
@route("/widgets/{id}/analyze")
@post
op Widgets_analyze(
  @path id: string,
): /** The request has succeeded. */ Body<string> | GeneratedHelpers.DefaultResponse<
  Description = "An unexpected error response.",
  Body = Error
>;

namespace Parameters {
  namespace Widget {
    model id {
      @path id: string;
    }
  }
}
namespace GeneratedHelpers {
  @doc(Description)
  @error
  model DefaultResponse<
    Description extends valueof string = "",
    Body = void,
    Headers extends {} = {}
  > {
    @body body: Body;
    ...Headers;
  }
}
