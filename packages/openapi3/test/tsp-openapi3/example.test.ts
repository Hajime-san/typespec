import { describe, expect, it } from "vitest";
import { renderTypeSpecForOpenAPI3 } from "./utils/tsp-for-openapi3.js";

describe("nested property descriptions", () => {
  it("generates doc comments from nested property descriptions", async () => {
    const tsp = await renderTypeSpecForOpenAPI3({
      paths: {
        "/": {
          get: {
            operationId: "extensive",
            parameters: [],
            responses: {
              "200": {
                description: "The request has succeeded.",
                content: {
                  "application/json": {
                    schema: {
                      $ref: "#/components/schemas/Dog",
                    },
                  },
                },
              },
            },
          },
        },
      },
      schemas: {
        Dog: {
          properties: {
            object: {
              type: "object",
              example: {
                object_nested: "nested value",
              },
              properties: {
                object_nested: {
                  type: "string",
                  example: "nested value",
                },
              },
              required: ["object_nested"],
            },
            number: {
              type: "number",
              example: 123,
            },
            boolean: {
              type: "boolean",
              example: false,
            },
            array: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  array_field: {
                    type: "string",
                  },
                },
                required: ["array_field"],
              },
              example: [{ array_field: "value1" }, { array_field: "value2" }],
            },
            string_without_format: {
              type: "string",
              example: "123",
            },
            string_byte: {
              type: "string",
              format: "byte",
              example: "U3BlYWtlYXN5IG1ha2VzIHdvcmtpbmcgd2l0aCBBUElzIGZ1biE=",
            },
            string_binary: {
              type: "string",
              format: "binary",
              example: "0101010101010101",
            },
            string_date: {
              type: "string",
              format: "date",
              example: "2023-01-01",
            },
            string_date_time: {
              type: "string",
              format: "date-time",
              example: "2023-01-01T12:00:00Z",
            },
            string_time: {
              type: "string",
              format: "time",
              example: "12:00:00Z",
            },
            string_duration: {
              type: "string",
              format: "duration",
              example: "P1Y1D",
            },
            string_uri: {
              type: "string",
              format: "uri",
              example: "https://example.com",
            },
            oas3_1_byte: {
              type: "string",
              // @ts-expect-error FIXME: OpenAPI 3.1+ only
              contentMediaType: "text/plain",
              contentEncoding: "base64",
              example: "U3BlYWtlYXN5IG1ha2VzIHdvcmtpbmcgd2l0aCBBUElzIGZ1biE=",
            },
          },
          required: [
            "number",
            "boolean",
            "object",
            "array",
            "string_without_format",
            "string_byte",
            "string_binary",
            "string_date",
            "string_date_time",
            "string_time",
            "string_duration",
            "string_uri",
            "oas3_1_byte",
          ],
        },
      },
    });

    expect(tsp).toMatchInlineSnapshot(`
"import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using Http;
using OpenAPI;

@service(#{ title: "Test Service" })
@info(#{ version: "1.0.0" })
namespace TestService;

model Dog {
  @example(#{ object_nested: "nested value" }) object: {
    @example("nested value")
    object_nested: string;
  };
  @example(123) number: numeric;
  @example(false) boolean: boolean;
  @example(#[#{ array_field: "value1" }, #{ array_field: "value2" }]) array: {
    array_field: string;
  }[];
  @example("123") string_without_format: string;
  @format("byte")
  @example("U3BlYWtlYXN5IG1ha2VzIHdvcmtpbmcgd2l0aCBBUElzIGZ1biE=")
  string_byte: bytes;
  @format("binary") @example("0101010101010101") string_binary: bytes;
  @example(plainDate.fromISO("2023-01-01")) string_date: plainDate;
  @example(utcDateTime.fromISO("2023-01-01T12:00:00Z")) string_date_time: utcDateTime;
  @example(plainTime.fromISO("12:00:00Z")) string_time: plainTime;
  @example(duration.fromISO("P1Y1D")) string_duration: duration;
  @example("https://example.com") string_uri: url;

  @encode("base64", string)
  @example("U3BlYWtlYXN5IG1ha2VzIHdvcmtpbmcgd2l0aCBBUElzIGZ1biE=")
  @JsonSchema.contentMediaType("text/plain")
  @JsonSchema.contentEncoding("base64")
  oas3_1_byte: bytes;
}

@route("/") @get op extensive(): Dog;
"
    `);
  });
});
