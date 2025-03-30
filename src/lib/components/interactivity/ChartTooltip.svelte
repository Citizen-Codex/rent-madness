<script lang="ts">
	import { computePosition, offset, flip, shift, autoUpdate } from '@floating-ui/dom';
	import { onDestroy } from 'svelte';
	import { fade } from 'svelte/transition';
	let { targetId, children } = $props();

	let tooltip = $state<HTMLElement>();
	let target = $derived(document.querySelector(`#${targetId}`));

	let cleanup = () => {};

	$effect(() => {
		if (!tooltip || !target) return;
		cleanup = autoUpdate(target, tooltip, () => {
			if (!tooltip) return;
			computePosition(target, tooltip, {
				placement: 'bottom',
				middleware: [offset(5), flip(), shift()],
				strategy: 'absolute'
			}).then(({ x, y }) => {
				if (!tooltip) return;
				Object.assign(tooltip.style, {
					top: `${y}px`,
					left: `${x}px`
				});
			});
		});
	});

	onDestroy(cleanup);
</script>

<div
	in:fade={{ duration: 150 }}
	bind:this={tooltip}
	class="pointer-events-none absolute top-0 left-0 z-40 w-max max-w-sm rounded border border-black bg-white px-4 py-3 shadow"
>
	{@render children?.()}
</div>
