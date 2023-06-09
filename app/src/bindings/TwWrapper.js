// https://www.npmjs.com/package/twrnc
// add wrapper b/c rescript doesn't support template literal functions
import { create } from "twrnc";

const tw = create(require(`../../tailwind.config`));

export function twWrapper(str) {
  return tw`${str}`;
}
