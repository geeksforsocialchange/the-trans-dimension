import { Given, When, Then } from "@cucumber/cucumber";
import { chromium } from "playwright";
import assert from "assert";

let browser, page;

When("I visit the homepage", async () => {
  browser = await chromium.launch({ headless: true });
  page = await browser.newPage();
  await page.goto("http://localhost:3030/");
});

Then("I see an image with the alt text {string}", async (altText) => {
  const imageElement = await page.locator(`img[alt="${altText}"]`);
  const isVisible = await imageElement.isVisible();

  // Assert that the image is visible
  assert.strictEqual(
    isVisible,
    true,
    `Image with alt text "${altText}" is not visible`
  );
});

Then("I see the text {string}", async (expectedText) => {
  const pageContent = await page.textContent("body"); // Get the text content of the entire page
  const isTextPresent = pageContent.includes(expectedText);

  // Assert that the text is present
  if (!isTextPresent) {
    throw new Error(`Expected text "${expectedText}" not found on the page.`);
  }
});
