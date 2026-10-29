import { compact, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Sections Pi's own summary tends to leave out; in my compaction eval they lifted answers from 68% to 79%, and failed
// attempts from 44% to 84% (brain: oss/pi-extensions/compaction-eval)
const INSTRUCTIONS = `Also include these sections:
## Tried and Failed
Every approach, command or fix that was tried and didn't work, with why it failed and the exact error message.
## Decisions and Reasons
Each decision, the reason for it, and the alternatives that were rejected.
## User Instructions
The user's instructions, preferences and corrections, close to their own words.
## Current State
What was being done at the end, what is verified, and the exact next step.
Keep exact names, paths, numbers, commands and error messages.`;

// pi-vcc's /pi-vcc marks its own compactions with this instruction and writes their summary itself
const PI_VCC = "__pi_vcc__";

export default function (pi: ExtensionAPI) {
	pi.on("session_before_compact", async (event, ctx) => {
		if (!ctx.model || event.customInstructions?.includes(PI_VCC)) return;
		// Anything that goes wrong leaves the compaction to Pi, as if this extension weren't there
		try {
			const auth = await ctx.modelRegistry.getApiKeyAndHeaders(ctx.model);
			if (!auth.ok) return;
			const instructions = event.customInstructions ? `${event.customInstructions}\n\n${INSTRUCTIONS}` : INSTRUCTIONS;
			const model = auth.baseUrl ? { ...ctx.model, baseUrl: auth.baseUrl } : ctx.model;
			const compaction = await compact(event.preparation, model, auth.apiKey, auth.headers, instructions, event.signal, pi.getThinkingLevel(), undefined, auth.env);
			return { compaction };
		} catch (err) {
			if (event.signal?.aborted) throw err;
			return;
		}
	});
}
