<script lang="ts">
	import { Popover } from 'bits-ui';
	import { fly } from 'svelte/transition';

	const chapters = [
		{ title: 'Introduction', href: '#introduction' },
		{ title: 'The Real Stakes', href: '#stakes' },
		{ title: 'Explore', href: '#explore' },
		{ title: 'Policy Implications', href: '#implications' },
		{ title: 'Types of Rental Data', href: '#types' },
		{ title: 'Divergence of Rental Data', href: '#divergence' },
		{ title: 'How to Improve', href: '#solutions' },
		{ title: 'Conclusion', href: '#conclusion' }
	];

	let popoverOpen = $state(false);
</script>

<Popover.Root bind:open={popoverOpen}>
	<Popover.Trigger
		class="fixed top-4 left-4 z-50 flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-black bg-white transition-transform hover:scale-110"
	>
		<iconify-icon icon="heroicons-outline:menu-alt-1" class="text-2xl text-black"></iconify-icon>
	</Popover.Trigger>
	<Popover.Content
		align="start"
		sideOffset={10}
		preventScroll={true}
		class="z-50 rounded border border-black bg-white py-1 shadow"
		forceMount={true}
	>
		{#snippet child({ wrapperProps, props, open })}
			{#if open}
				<div {...wrapperProps}>
					<div {...props} transition:fly={{ y: -10 }}>
						{#each chapters as { title, href }, i (i)}
							<a
								{href}
								onclick={() => (popoverOpen = false)}
								class={[
									'cta-small flex items-center gap-2 px-4 py-1 font-normal normal-case hover:bg-black/20'
								]}
							>
								<div class="h-0.5 w-3 rounded-full bg-black"></div>
								{title}
							</a>
						{/each}
					</div>
				</div>
			{/if}
		{/snippet}
	</Popover.Content>
</Popover.Root>
