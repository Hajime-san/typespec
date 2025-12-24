import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "OneAnyAll Service" })
@info(#{ version: "0.0.0" })
namespace OneAnyAllService;

model Cat {
  ...Pet;
  hunts: boolean;
}

model Dog {
  ...Pet;
  bark: boolean;
  breed: "Husky" | "Corgi" | "Terrier";
}

@oneOf
union One {
  Dog,
  Cat,
}

union Any {
  Dog,
  Cat,
}

model Pet {
  age: int32;
}

@route("/any") @post op putAny(
  @body body: {
    pet: Dog | Cat;
  },
): /** There is no content to send for this request, but the headers may be useful.  */ NoContentResponse;

@route("/one") @post op putOne(
  @body body: {
    @oneOf
    pet: Dog | Cat;
  },
): /** There is no content to send for this request, but the headers may be useful.  */ NoContentResponse;

@route("/any/schema") @post op putAnySchema(
  @body body: {
    pet: Any;
  },
): /** There is no content to send for this request, but the headers may be useful.  */ NoContentResponse;

@route("/one/schema") @post op putOneSchema(
  @body body: {
    pet: One;
  },
): /** There is no content to send for this request, but the headers may be useful.  */ NoContentResponse;
