// Compute FROM_DATE and TO_DATE at build time, then run the given command.
// FROM_DATE = 1 month ago, TO_DATE = 6 months from now.
// Retries on failure to handle transient network issues (e.g. Elm package registry timeouts).
import { execSync } from "node:child_process";

const now = new Date();
const from = new Date(now);
from.setMonth(from.getMonth() - 1);
const to = new Date(now);
to.setMonth(to.getMonth() + 6);

const fmt = (d) => d.toISOString().slice(0, 10) + " 00:00";

process.env.FROM_DATE = process.env.FROM_DATE || fmt(from);
process.env.TO_DATE = process.env.TO_DATE || fmt(to);

const command = process.argv.slice(2).join(" ") || "elm-constants && elm-pages build";
const maxRetries = 3;

for (let attempt = 1; attempt <= maxRetries; attempt++) {
  try {
    execSync(command, { stdio: "inherit", env: process.env });
    break;
  } catch (error) {
    if (attempt < maxRetries) {
      const delay = attempt * 30;
      console.error(`Build attempt ${attempt}/${maxRetries} failed. Retrying in ${delay}s...`);
      execSync(`sleep ${delay}`);
    } else {
      console.error(`Build failed after ${maxRetries} attempts.`);
      process.exit(error.status || 1);
    }
  }
}
