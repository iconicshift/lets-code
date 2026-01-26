import { test, expect } from "@playwright/test";

test("GET /healthz returns 200 when database is available", async ({
  request,
}) => {
  const response = await request.get("/healthz");

  expect(response.status()).toBe(200);
  expect(await response.text()).toBe("OK!\n");
});
